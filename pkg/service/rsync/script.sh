#!/bin/bash

source $DIR_ADMIN/conf/script/system.sh


Simulate()
# ------------------------
{
  CheckParam "$0->$FUNCNAME(aCmd=$1)" $# 1 1
  aCmd=$1;
  Log "$0->$FUNCNAME, $aCmd"
 
  echo "Simulate mode"
  rsync --dry-run $aCmd
 
  if YesNo "Synchronize" 60 0; then
    rsync $aCmd
  fi;
}


Sync_Soft()
# ------------------------
{
  Log "$0->$FUNCNAME"

  DstHost=$gVpnServIP
  SrcDir="$gDirData/share/Public/Soft_1"

  # copy from DstHost to localhost
  Cmd="--verbose --progress --recursive --links --times --delete ${DstHost}::Soft $SrcDir"
  Simulate "$Cmd"
}


Sync_Conf()
# ------------------------
{
  Log "$0->$FUNCNAME"

  DstHost=$gVpnServIP
  SrcDir=$gDirConf

  # copy from DstHost to localhost
  Cmd="--verbose --progress --recursive --links --times --delete ${DstHost}::AdminFull $SrcDir"
  #Cmd="--update --verbose --progress --recursive --links --times ${DstHost}::Conf $SrcDir"
  Simulate "$Cmd"
}


Sync_ConfImport()
# ------------------------
{
  Log "$0->$FUNCNAME"

  #DstHost="oster.com.ua"
  DstHost="192.168.2.111"
  SrcDir=$gDirConf

  # copy from DstHost to localhost
  # mkdir /admin/conf && rsync --dry-run --update --verbose --progress --recursive --links --times tr24.oster.com.ua::AdminFull /admin/conf
  Cmd="--update --verbose --progress --recursive --links --times ${DstHost}::AdminFull $SrcDir"
  Simulate "$Cmd"
}


# ------------------------
clear
case $1 in
    soft)	Sync_Soft	$2 ;;
    conf)	Sync_Conf	$2 ;;
    confi)	Sync_ConfImport	$2 ;;
esac


