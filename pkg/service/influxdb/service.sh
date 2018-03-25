#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


Init()
{
  Log "$0->$FUNCNAME"

  # adjust /etc/shells
}


InstallEx()
{
  Log "$0->$FUNCNAME"

  wget https://dl.influxdata.com/influxdb/releases/influxdb_1.4.3_amd64.deb
  dpkg -i influxdb_1.4.3_amd64.deb

}


# ------------------------
clear
case $1 in
    Exec|e)	Exec	        $2 ;;
    Install)	InstallEx	$2 ;;
    *)		Test	        ;;
esac
