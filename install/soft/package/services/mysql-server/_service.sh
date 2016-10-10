#!/bin/bash
#--- VladVons@gmail.com


. ./_const.sh
. ./_script.sh
. $DIR_ADMIN/conf/Service.sh


TestEx()
{
  Test

  #mysqldumpslow /var/db/mysql/slow-queries.log

  #echo
  #ShowVar
}


ExecEx()
# ------------------------
{
  aAction=${1:-"restart"}

  #Exec $aAction    

  eval "service $Process $aAction"
  sleep 3

  TestEx
}


Init()
#------------------------
{
  Log "$0->$FUNCNAME"

  mysqladmin -u $gMySQLUser password $gMySQLPassw
  Exec
}


Remove()
{
  Log "$0->$FUNCNAME"

  service $Process stop
  deluser mysql  
  PkgRemove "--purge mysql-server mysql-client mysql-common"
}

# ------------------------
clear
case $1 in
    Exec|e)	ExecEx	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    Remove)	$1	$2 ;;
    *)		TestEx	;;
esac
