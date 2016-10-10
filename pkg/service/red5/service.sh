#!/bin/bash
#--- VladVons@gmail.com


source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


ExecEx()
{
  Exec
}


TestEx()
{
  Test
  
  java -version
}


init()
# ------------------------
{
  Log "$0->$FUNCNAME"
}


# ------------------------
clear
case $1 in
    Exec|e)     ExecEx	$2 ;;
    Install)    $1      $2 ;;
    Init)       $1      $2 ;;
    *)		TestEx	;;
esac
