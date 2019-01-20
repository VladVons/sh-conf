#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/system.sh


# ------------------------
Init()
{
  aCompany=$1

  Company=$aCompany
  DirKey=$(pwd)/key
  #mkdir -p $DirKey
  . ./vars
  cd $cDirRsa
}


GenServer()
{
  CheckParam "CheckFile(aCompany='$1')" $# 1 1
  aCompany=$1
  Log "$0->$FUNCNAME, $aCompany"

  Init $aCompany

  echo "clean-all"
  ./clean-all

  echo "build-ca"
  ./build-ca
  
  echo "build-dh"
  ./build-dh

  echo "build-key-server"
  ./build-key-server $aCompany

  echo "ta.key"
  openvpn --genkey --secret $DirKey/$aCompany/ta.key
}


GenClient()
{
  CheckParam "CheckFile(aCompany='$1', aName='$2')" $# 2 2
  aCompany=$1; aName=$2
  Log "$0->$FUNCNAME, $aCompany, $aName"

  Init $aCompany
  ./build-key $aName
}


Reserved()
{
  Log "$0->$FUNCNAME"


  echo "http://www.sergeysl.ru/freebsd-openvpn-client-static-ip"
  echo "IP pairs are: [1-2], [5-6], ... [253-254]"
  seq 1 4 253 | xargs

  Dir="oster"
  echo
  grep --dereference-recursive "ifconfig" "etc/openvpn/$Dir/ccd" | awk '{print $3,$2,$1}' | sort -V

  echo
  grep --dereference-recursive "iroute" "etc/openvpn/$Dir/ccd" | awk '{print $2,$1}' | sort -V
}


# ------------------------
case $1 in
    GenClient)	$1 $2 $3 ;;
    GenServer)	$1 $2 $3 ;;
    Reserved)	$1 $2 $3 ;;
esac
