#!/bin/bash
#--- VladVons@gmail.com


source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


# ping online
# http://centralops.net/co/


ExecEx()
{
  Exec

  ExecM "rndc reload"
}


TestEx()
{
  Test
}


InstallEx()
# ------------------------
{
  Log "$0->$FUNCNAME"

  wget -q -O - http://download.opensuse.org/repositories/isv:ownCloud:community/xUbuntu_14.04/Release.key | apt-key add -
  echo "deb http://download.opensuse.org/repositories/isv:/ownCloud:/community/xUbuntu_14.04 /" > /etc/apt/sources.list.d/owncloud.list
  apt-get update -y
  PkgInstall "$cPkgName"

  mysql -u root -p
  CREATE DATABASE owncloud;
  GRANT ALL ON app_owncloud.* to 'owncloud'@'localhost' IDENTIFIED BY 'owncloud2015';
}


# ------------------------
clear
case $1 in
    Exec|e)     ExecEx	  $2 ;;
    Install)    InstallEx $2 ;;
    Init)       $1        $2 ;;
    *)		TestEx	;;
esac
