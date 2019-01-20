#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source ./script.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
{
  Test
}


InstallEx()
{
  wget https://deb.nodesource.com/setup_11.x 
  chmod 755 setup_11.x
  ./setup_11.x

  apt-get install --yes --force-yes nodejs
  apt-get install --yes npm

  #npm install -g @angular/cli
}


InstallEx
# ------------------------
case $1 in
    Install)	InstallEx	$2 $3 $4;;
    *)		TestEx		;;
esac
