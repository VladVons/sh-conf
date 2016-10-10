#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


ExecEx()
# ------------------------
{
  aAction=${1:-"restart"}
  Log "$0->$FUNCNAME, $cProgram, $aAction"

  #Exec $aAction
  service $cProcess $aAction 
  sleep 3

  Test
}


InstallEx()
# ------------------------
{
  Log "$0->$FUNCNAME"

  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/postgresql.list
  apt-get update

  PkgInstall "$Package"
}


# ------------------------
clear
case $1 in
    Exec|e)	ExecEx		$2 ;;
    Init)	$1 		$2 ;;
    Install)	InstallEx	$1 $2 ;;
    *)		Test		;;
esac
