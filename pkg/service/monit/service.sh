#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
{
  Test

  ExecM "monit -t"
  #ExecM "monit start all"
}


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  #http://mmonit.com/monit/documentation/monit.html#filesystem_flags_testing
  ExecM "adduser www-data video"
}


# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		TestEx	;;
esac
