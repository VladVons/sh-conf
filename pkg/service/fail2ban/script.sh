#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


Clear()
{
  Log "$0->$FUNCNAME"

  service $cProcess stop

  cd $DIR_ADMIN/conf/pkg/console/iptables-persistent
  ./script.sh RulesClear
  ./script.sh RulesExecute

  ExecM "echo > $cLog_freeswitch"
  ExecM "echo > $cLog_fail2ban"
  ExecM "echo > $cLog_ssh"
  ExecM "echo > $cBlackList"

  service $cProcess start
}


RulesTest()
{
  verb="-v"
  ExecM "fail2ban-regex $verb $cLog_freeswitch /etc/fail2ban/filter.d/freeswitch.conf"
  #ExecM "fail2ban-regex $verb $cLog_fail2ban   /etc/fail2ban/filter.d/fail2ban.conf"
}


GetBanCountry()
{
  Log "$0->$FUNCNAME"

  cnt=0
  iptables -S | grep -E "REJECT|DROP" | sort -V | uniq | \
  while read i; do
    ip=`echo $i | grep -E -o "([0-9]{1,3}[.]){3}[0-9]{1,3}"`
    country=$(geoiplookup -l $ip | grep -i "country")
    ((cnt++))
    echo $cnt, $ip, ${country##*:}
  done
}


SaveBanIP()
{
  Log "$0->$FUNCNAME"

  File=$cBlackList

  #(grep " Ban " $cLog1 && \
    #iptables -S | grep -E "REJECT|DROP") | \
    #grep -E -o "([0-9]{1,3}[.]){3}[0-9]{1,3}" | sort | uniq > ${File}
  (grep " Ban " $cLog1) | \
    grep -E -o "([0-9]{1,3}[.]){3}[0-9]{1,3}" | sort | uniq > ${File}


  echo "saved to $File. See action.d/iptables-allports-file.conf"=
}


# ------------------------
case $1 in
    Clear)	$1	$2 ;;
    RulesTest)	$1	$2 ;;
    GetBanCountry)	$1	$2 ;;
    SaveBanIP)	$1	$2 ;;
esac
