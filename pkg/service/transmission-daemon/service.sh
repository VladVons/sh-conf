#!/bin/bash
#--- VladVons@gmail.com


source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


ExecEx()
{
  Log "$0->$FUNCNAME"

  #invoke-rc.d transmission-daemon reload
  Exec
}


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  touch $cLog1
  chown $cUser $cLog1

  ExecM "mkdir -p $cDirRoot/downloads-part"
  ExecM "chown -R $cUser:$cUser $cDirRoot/ "

  # Set password:
  # /etc/default/transmission-daemon doesnt work in DEB
  #.
  # service transmission stop
  # edit file /etc/transmission-daemon/settings.json and set:
  # "rpc-password : "MyPassword"
  # "rpc-authentication-required": false
  # service transmission start
.
  # error: Failed to set receive buffer
  #echo 'net.core.rmem_max = 16777216' >> /etc/sysctl.conf
  #echo 'net.core.wmem_max = 4194304' >> /etc/sysctl.conf
  #sysctl -p

  # transmission web interface
  # http://localhost:9091
}


# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		Test	;;
esac
