#!/bin/bash
#--- VladVons@gmail.com

source $DIR_ADMIN/conf/script/service.sh


# ------------------------
clear
case $1 in
    Install)	Install	$2 $3 $4;;
    *)		Test		;;
esac
