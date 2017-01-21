#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"
  adduser linux epoptes

  # mcedit  /etc/init.d/epoptes-client

  # set xxx.xxx.xxx.xxx server
  # mcedit  /etc/hosts

  # copy serteficate from machine 'server' 
  epoptes-client -c
}


# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    *)		Test	;;
esac
