#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/utils.sh

#http://www.freebsdwiki.net/index.php/BIND,_dynamic_DNS


DynDNS()
{
  Log "$0->$FUNCNAME"

  Key="dyn_oster_com_ua"

  mkdir -p $DirDyn
  chmod 775 $DirDyn
  chown bind $DirDyn
 
  cd $DirDyn
  dnssec-keygen -b 512 -a HMAC-MD5 -n HOST $Key

  cat *.private
  dig @localhost $Key

  echo "Note! copy 2 files to client side (.private & .key)"
}


ClientUpdate()
{
  Log "$0->$FUNCNAME"

  HostPrefix=$(hostname | awk -F. '{ print $1 }')
  IP=$(wget -qO - ipecho.net/plain)
 
  TTL="3600"
  ServerNS="ns.oster.com.ua"
  HostName="${HostPrefix}.oster.com.ua."
  Zone="oster.com.ua"
  KeyFile="Kdyn.oster.com.ua.+157+20872.private"

  echo "IP=$IP, TTL=$TTL, ServerNS=$ServerNS, HostName=$HostName, Zone=$Zone, KeyFile=$DirDyn/$KeyFile"

nsupdate -d -k $DirDyn/$KeyFile -v << EOF
debug yes
server $ServerNS
zone $Zone
update delete $HostName A
update add $HostName $TTL A $IP
show
answer
send
EOF

  sleep 3 
  ExecM "dig @${ServerNS} $HostName"

  #check and run all up scripts in /etc/network/if-up.d
  #ifup --all -v
}


# ------------------------
clear
case $1 in
    DynDNS)    		$1 $2 $3 ;;
    ClientUpdate)	$1 $2 $3 ;;
esac
