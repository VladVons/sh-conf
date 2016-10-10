#!/bin/bash
#--- VladVons@gmail.com


source ./const.sh
source ./script.sh
source $DIR_ADMIN/conf/script/service.sh


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  ExecM "mkdir -p $gDirSvn" 	"Creating repository dir and its owner $gDirSvn" 

  # svn via apache
  a2enmod dav
  a2enmod dav_fs

  #pw group del $gOwner
  #pw user del $gOwner
  #pw group add $gOwner
  #pw user add $gOwner -g $gOwner -s /sbin/nologin -d $gDirSvn

  #chown -R $gOwner:$gOwner $gDirSvn

  cServiceAutostart $cApp 1

  #RepAdd "jdv"
 
  #modify reposName/svnserve.conf reposName/passwd and test it
  #svn checkout svn://localhost/jdv MyTemp --username vv --password jdv2012
  #svn checkout svn://localhost/tr21-conf MyTemp --username VladVons --password 19710819
}


Info()
{
 svnadmin help
}


# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    Info)	$1	$2 ;;
    *)		Test	;;
esac
