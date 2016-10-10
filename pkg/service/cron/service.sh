#!/bin/bash

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
# ------------------------
{
  Test

  #ExecM "crontab -l"
  #ExecM "run-parts --test /etc/cron.daily"
}


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"
 
  #user personal task
  #crontab -u root $DIR_ADMIN/conf/cron/root
  #crontab -u root -e
}


Info()
# ------------------------
{
  Log "$0->$FUNCNAME"

  #to disable mailing add to /etc/crontab
  #MAILTO=""
}


# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		TestEx	;;
esac
