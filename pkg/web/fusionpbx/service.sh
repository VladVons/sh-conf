#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source ./script.sh
source $DIR_ADMIN/conf/script/service.sh


InstallEx()
{
  Log "$0->$FUNCNAME"

  cd /usr/src
  apt-get install --yes git
  git clone https://github.com/fusionpbx/fusionpbx-install.sh.git
  chmod 755 -R /usr/src/fusionpbx-install.sh
  cd /usr/src/fusionpbx-install.sh/debian
  ./install.sh

  #https://ip_address
}


# ------------------------
clear
case $1 in
    Install)	InstallEx	$2 ;;
    *)		Test		;;
esac
