#!/bin/bash
#--- VladVons@gmail.com


. ./_const.sh
. $DIR_ADMIN/conf/Service.sh


# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Install)	$1	$2 ;;
    *)		Test	;;
esac
