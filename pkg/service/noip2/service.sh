#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
# ------------------------
{
  Test
  
  noip2 -S
}



Init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  ExecM "noip2 -C"	"Configure"
  #ExecM "noip2 -U 120"	"Uptime interval"
}


InstallEx()
# ------------------------
{
  Log "$0->$FUNCNAME"

  Install

  File="noip-duc-linux.tar.gz"
  DirSrc="/usr/local/src/$cApp"
  DirApp="noip-2.1.9-1"
  
  mkdir -p $DirSrc
  cd $DirSrc

  wget http://www.noip.com/client/linux/$File
  tar xf $File
  cd $DirApp

  rm $App
  make install

  # autostart
  cp $DirSrc/$DirApp/debian.noip2.sh $gDirD/noip2
  chmod 755 $gDirD/noip2
  $gDirD/noip2 start

  rm -R $DirSrc
}


# ------------------------
clear
case $1 in
    Exec|e)	Exec		$2 ;;
    Init)	$1		$2 ;;
    Install)	InstallEx	$2 ;;
    *)		TestEx		;;
esac
