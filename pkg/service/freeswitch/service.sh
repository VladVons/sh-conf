#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source ./script.sh
source $DIR_ADMIN/conf/script/service.sh

#source $DIR_ADMIN/conf/sys/cron/tasks/a0_BlackList


TestEx()
{
  Test

  #Status
  ExecM "fs_cli -x 'show registrations'"
}


AddRepository()
{
  Log "$0->$FUNCNAME"

  #https://freeswitch.org/confluence/display/FREESWITCH/Debian+8+Jessie
  wget -q -O - http://files.freeswitch.org/repo/deb/debian/freeswitch_archive_g0.pub | apt-key add -
  #echo "deb http://files.freeswitch.org/repo/deb/freeswitch-1.6/ jessie main" > /etc/apt/sources.list.d/freeswitch.list
  echo "deb http://files.freeswitch.org/repo/deb/freeswitch-1.4/ jessie main" > /etc/apt/sources.list.d/freeswitch.list
  apt-get update

  apt-cache search freeswitch | sort
  #dpkg -l | grep freeswitch | sort
}


InstallGUI()
{
  Log "$0->$FUNCNAME"

  #cd /usr/src
  #wget https://raw.githubusercontent.com/fusionpbx/fusionpbx-scripts/master/install/ubuntu/install_fusionpbx.sh
  #chmod 755 install_fusionpbx.sh
  #./install_fusionpbx.sh install-fusionpbx user

  cd /usr/src
  apt-get install --yes git
  git clone https://github.com/fusionpbx/fusionpbx-install.sh.git
  chmod 755 -R /usr/src/fusionpbx-install.sh
  cd /usr/src/fusionpbx-install.sh/debian
  ./install.sh

  #https://ip_address
}


InstallEx()
{
  Log "$0->$FUNCNAME"

  AddRepository
  Install
  #InstallGUI
}




# ------------------------
clear
case $1 in
    Exec|e)	Exec		$2 ;;
    Install)	InstallEx	$2 ;;
    *)		TestEx		;;
esac
