#!/bin/bash
#--- VladVons@gmail.com


source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Install)	$1	$2 ;;
    *)		Test	;;
esac
