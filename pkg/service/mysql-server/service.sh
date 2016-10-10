#!/bin/bash
#--- VladVons@gmail.com


source ./const.sh
source ./script.sh
source $DIR_ADMIN/conf/script/service.sh


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

  eval "service $cProcess $aAction"
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

  cService $cProcess stop
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
