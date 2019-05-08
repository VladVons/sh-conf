#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh

# https://wiki.debian.org/GmailAndExim4

Init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  # update exim4 after configuring files /etc/exim4/passwd.client, /etc/email-addresses
  update-exim4.conf
  invoke-rc.d exim4 restart
  exim4 -qff
}


# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		Test	;;
esac
