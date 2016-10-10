#!/bin/bash
#--- VladVons@gmail.com


source ./const.sh
source $DIR_ADMIN/conf/script/service.sh

# Win thin client
# http://frenzy.org.ua/ru/releases/rdpclient/
# http://anywherets.com/products/anywherets/download


# ------------------------
clear
case $1 in
    Exec|e)     $1	$2 ;;
    Install)    $1      $2 ;;
    *)		Test	;;
esac
