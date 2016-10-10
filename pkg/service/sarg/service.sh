#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source ./script.sh
source $DIR_ADMIN/conf/script/service.sh


ExecEx()
# ------------------------
{
  Log "$0->$FUNCNAME"

  OneDay
}


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  Dir1=$gDirData/sarg
  mkdir -p $Dir1
  ln -s $Dir1 /var/www/html

  #AddUserHtpasswd VladVons 19710819 ${Dir1}/Users
  #AddUserHtpasswd 192_168_2_101 19710819 $Dir1/Users
}


# ------------------------
clear
case $1 in
    Exec|e)	ExecEx	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		Test	;;
esac
