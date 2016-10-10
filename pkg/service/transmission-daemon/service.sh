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
