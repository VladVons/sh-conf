#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


InstallGUI()
# ------------------------
{
  Log "$0->$FUNCNAME"

  PkgInstallTry git
  git clone git://github.com/pommi/CGP.git /var/www/html/app/cgp

  #ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled
  a2enmod rewrite
  apachectl graceful
}


InstallEx()
# ------------------------
{
  Log "$0->$FUNCNAME"

  PkgInstall "$cPkgName"
  #InstallGUI

  # smartmon
  #https://gist.github.com/jinnko/6366979
}


Clear()
# ------------------------
{
  Log "$0->$FUNCNAME"
  
  $cService $cApp stop 
  sleep 1
  rm -R /var/lib/collectd/rrd/*
  $cService $cApp start
}


# ------------------------
clear
case $1 in
    Exec|e)	Exec		$2 ;;
    Init)	$1		$2 ;;
    Install)	InstallEx	$2 ;;
    Clear)	$1		$2 ;;
    *)		Test ;;
esac
