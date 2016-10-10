#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source ./script.sh 
source $DIR_ADMIN/conf/script/service.sh


TestEx()
# ------------------------
{
  Test

  echo
  ShowFile $cLog2 ST 25
 
  #echo "type 'quit' to exit"
  #telnet localhost 25

  #SendMail
}


# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Install)	$1	$2 ;;
    *)		TestEx	;;
esac
