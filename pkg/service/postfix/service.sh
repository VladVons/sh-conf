#!/bin/bash
#--- VladVons@gmail.com


source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
# ------------------------g
{
  Test

  #echo
  #telnet smtp.gmail.com 25

  #echo
  #echo "Body text" | mail -s "Subject text" VladVons@gmail.com
}


ExecEx()
# ------------------------
{
  aAction=${1:-"restart"}

  Exec $aAction
  #postfix reload
}


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  postfix check

  #make symbol link $gDirData/mail to /var/spool/mail 
}


# ------------------------
clear
case $1 in
    Exec|e)	ExecEx	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		TestEx	;;
esac
