#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/utils.sh


# ------------------------
clear
case $1 in
    DynDNS)    		$1 $2 $3 ;;
    ClientUpdate)	$1 $2 $3 ;;
esac
