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

  #update-rc.d grafana-server defaults
  ##systemctl daemon-reload
  ##systemctl enable grafana-server
  #systemctl start grafana-server

  source $DIR_ADMIN/conf/pkg/service/mysql-server/sql.sh
  dbCreateGrant "3w_grafana" "grafana" "grafana2018"

  #cd /usr/share/doc/zabbix-server-mysql
  #SQLFileGz create.sql.gz app_zabbix
}


InstallEx()
{
  Log "$0->$FUNCNAME"

  apt-get install apt-transport-https

  #wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_4.6.3_amd64.deb
  #apt-get install -y adduser libfontconfig
  #dpkg -i grafana_4.6.3_amd64.deb

  deb https://packagecloud.io/grafana/testing/debian/ jessie main
  curl https://packagecloud.io/gpg.key | sudo apt-key add -
  #
  #deb https://packagecloud.io/grafana/stable/debian/ jessie main
  #curl https://packagecloud.io/gpg.key | sudo apt-key add -
  apt-get update
  apt-get install grafana
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
