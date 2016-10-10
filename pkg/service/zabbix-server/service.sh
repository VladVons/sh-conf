#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source ./ppa.sh
source $DIR_ADMIN/conf/script/service.sh


# plugin
# https://addons.mozilla.org/uk/firefox/addon/live-http-headers/


ExecEx()
# ------------------------
{
  aAction=${1:-"restart"}

  Exec $aAction
  #apachectl graceful
}


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  source $DIR_ADMIN/conf/pkg/service/mysql-server/sql.sh

  dbCreateGrant "app_zabbix" "zabbix" "zabix2016"

  cd /usr/share/doc/zabbix-server-mysql
  SQLFileGz create.sql.gz app_zabbix
}


InstallEx()
{
  #https://www.digitalocean.com/community/tutorials/how-to-install-zabbix-on-ubuntu-configure-it-to-monitor-multiple-vps-servers

  AddPpa
  Install
  Init

  # user: Admin
  # passw: zabbix
  # http://192.168.2.106/zabbix/index.php
}


# ------------------------
clear
case $1 in
    Exec|e)	ExecEx		$2 ;;
    Init)	$1		$2 ;;
    Install)	InstallEx	$2 ;;
    AddPpa)	$1		$2 ;;
    *)		Test		;;
esac
