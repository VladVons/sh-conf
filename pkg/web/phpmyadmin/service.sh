#!/bin/bash
#--- VladVons@gmail.com


source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


InstallEx()
# ------------------------
{
  Log "$0->$FUNCNAME"
  
  Install
  apachectl graceful

  # url: http://localhost/phpmyadmin
  # MySQL user: root
  # MySQL passw: xxxxx
}


# ------------------------
clear
case $1 in
    Install)    InstallEx $2 ;;
    *)		Test	;;
esac
