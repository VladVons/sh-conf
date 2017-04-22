#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/system.sh


# ------------------------
Init()
{
  cd $cDirRsa
  . ./vars

  echo "Key storage output: $KEY_DIR"
  echo
}


NewClient()
{
  CheckParam "CheckFile(aName='$1')" $# 1 1
  aName=$1
  Log "$0->$FUNCNAME, $aName"

  Init
  ./build-key $aName
}


Reserved()
{
  Log "$0->$FUNCNAME"


  echo "http://www.sergeysl.ru/freebsd-openvpn-client-static-ip"
  echo "IP pairs are: [1-2], [5-6], ... [253-254]"
  seq 1 4 253 | xargs

  echo
  grep --dereference-recursive "ifconfig" "etc/openvpn/server1/ccd" | awk '{print $3,$2,$1}' | sort -V

  echo
  grep --dereference-recursive "iroute" "etc/openvpn/server1/ccd" | awk '{print $2,$1}' | sort -V
}


# ------------------------
case $1 in
    NewClient)	$1	$2 ;;
    Reserved)	$1	$2 ;;
esac
