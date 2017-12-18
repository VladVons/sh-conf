#!/bin/bash
#--- VladVons@gmail.com


source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
# ------------------------
{
  Test

  #echo
  #telnet smtp.mail.ru 25

  #ExecM "whereis mail"
  ExecM "ls /usr/sbin -l | grep sendmail"
  echo "Body text" | ssmtp -v -s "Subject test ssmtp" VladVons@gmail.com
  #echo "Body text" | mail     -s "Subject test mail" VladVons@gmail.com
}


# ------------------------
clear
case $1 in
    Exec|e)	ExecEx	$2 ;;
    Install)	$1	$2 ;;
    *)		TestEx	;;
esac
