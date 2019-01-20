#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
{
  Test

  #service apcupsd stop
  #apctest

  ExecM "dmesg | grep --ignore-case --color=auto American"
  ExecM "apcaccess status"
}


InitGui()
{
  Log "$0->$FUNCNAME"

  # gui monitor pcupsd-cgi at http://localhost/cgi-bin/apcupsd/multimon.cgi
  apt-get install pcupsd-cgi
  a2enmod cgid
  apachectl graceful
}


Init()
{
  Log "$0->$FUNCNAME"

  #http://www.apcupsd.com/manual/manual.pdf
}

 
# ------------------------
clear
case $1 in
    Exec|e)     Exec    $2 ;;
    Install)    $1      $2 ;;
    Init)    	$1      $2 ;;
    *)          TestEx	;;
esac
