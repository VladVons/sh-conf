#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/system.sh


gOwner="svn"


RepAdd()
# ------------------------
{
  CheckParam "$0->$FUNCNAME(aName='$1')" $# 1 1
  aName="$1"; 
  Log "$0->$FUNCNAME, $aName"

  svnadmin create "$gDirSvn/$aName"
  #chown -R $gOwner:$gOwner $gDirSvn

  # copy common conf 
  #mv $gDirSvn/$aName/conf $gDirSvn/$aName/conf-old
  #ln -s $gDirSvn/jdv/conf $gDirSvn/$aName/conf 
}


RepDel()
# ------------------------
{
  CheckParam "$0->$FUNCNAME(aName='$1')" $# 1 1
  aName="$1"; 
  Log "$0->$FUNCNAME, $aName"

  if YesNo "Remove repository $aName"; then
    rm -rf "$gDirSvn/$aName"
  fi;
}


RepDump()
# ------------------------
{
  CheckParam "$0->$FUNCNAME(aWait='$1', aWakeUp='$2')" $# 0 3
  aName="$1"; 
  Log "$0->$FUNCNAME, $aName"

  svnadmin dump "$gDirSvn/$aName" | zip > "$gDirBackupSvn/$aName.zip"
}


RepList()
# ------------------------
{
  Log "$0->$FUNCNAME"

  ls -1 $gDirSvn
}



# ------------------------
clear
case $1 in
    RepAdd)	$1	$2 ;;
    RepDel)	$1	$2 ;;
    RepDump)	$1	$2 ;;
    RepList)	$1	$2 ;;
esac
