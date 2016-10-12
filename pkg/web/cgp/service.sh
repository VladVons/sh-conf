#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


InstallEx()
# ------------------------
{
  Log "$0->$FUNCNAME"

  PkgInstallTry git
  git clone git://github.com/pommi/CGP.git /var/www/app/cgp

  #ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled
  a2enmod rewrite
  apachectl graceful
}

# ------------------------
clear
case $1 in
    Install)	InstallEx	$2 ;;
    *)		Test ;;
esac
