#!/bin/bash
#--- VladVons@gmail.com


source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


Init()
{
  # first time auth
  grive --path=./VladVons1 --auth

  # sync all
  #grive --path=./VladVons

  grive --path=./VladVons1 --upload-only --dir=Temp
  #grive --path=./VladVons1 --dir=Temp --upload-only --ignore="cache"
  #grive --path=./VladVons1 --upload-only --dir=Temp --ignore="cache" --dry-run
}


InstallEx()
# ------------------------
{
  Log "$0->$FUNCNAME"

  add-apt-repository ppa:nilarimogard/webupd8
  apt-get update

  Install
}


# ------------------------
clear
case $1 in
    Install)    InstallEx $2 ;;
    Init)       $1        $2 ;;
    *)		TestEx	;;
esac
