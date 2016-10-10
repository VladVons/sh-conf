#!/bin/bash
#--- VladVons@gmail.com


source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
# ------------------------
{
  Test
 
  ExecM "apache2ctl -M | grep php" "check PHP in apache"
 
  ExecM "php --modules | xargs"	"Loaded modules"
  ExecM "php --info | grep -i 'Configuration File'"
  ExecM "ls /usr/lib/php5/20131226" "Enabled modules"
}


ExecEx()
# ------------------------
{
  Log "$0->$FUNCNAME"

  $DIR_ADMIN/conf/pkg/service/apache2/service.sh e

  TestEx
}


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  Var1="/tmp/eaccelerator"
  mkdir -p $Var1
  chown www:www $Var1
 
  Var1="$gDirData/tmp/profiler"
  mkdir -p $Var1
  chown www:www $Var1

  #ln -s /etc/php5/cli/conf.d/mcrypt.ini /etc/php5/mods-available
  #php5enmod mcrypt
  #cService apache2 restart
}


InstallEx()
# ------------------------
{
  Log "$0->$FUNCNAME"

  Install

  pecl install geoip timezonedb

  # php accelerator php-apc
  php5enmod opcache
}


# ------------------------
clear
case $1 in
    Exec|e)	ExecEx		$2 ;;
    Init)	$1		$2 ;;
    Install)	InstallEx	$1 $2 ;;
    *)		TestEx		;;
esac
