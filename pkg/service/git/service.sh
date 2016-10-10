#!/bin/bash 
#--- VladVons@gmail.com


source ./const.sh
source ./script.sh
source $DIR_ADMIN/conf/script/service.sh


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  #adduser --disabled-login --gecos 'GitLab' git
  #passwd git

  #git config --global user.name "Vladimir Vons"
  #git config --global user.email "Vladvons@gmail.com"
  #git config --list

  #https://habrahabr.ru/post/43806/
  a2enmod dav
  a2enmod dav_fs
  a2enmod rewrite
  a2enmod env
  apachectl -k graceful
}



# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		Test	;;
esac
