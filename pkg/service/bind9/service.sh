#!/bin/bash
#--- VladVons@gmail.com


source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


# ping online
# http://centralops.net/co/


ExecEx()
{
  Exec

  ExecM "rndc reload"
}


TestEx()
{
  Test
  ShowFile $Log3 SGT "dyn" 15

  ExecM "named -v" "get version info"

  #if not, then see resolv.conf for 'nameserver 127.0.0.1'
  #ping test.${gHostName}

  #ExecM "ifconfig | grep inet"         
  #ExecM "nslookup www.google.com"      
  #ExecM "named -g -p 53"
  #ExecM "host -v oster.com.ua"

  #ExecM "host -v $gExtIP"      "check reverse DNS"
  #ExecM "dig -x IP $gExtIP"    "check reverse DNS" 

}


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  mkdir -p $DirEtc/{ext,int}

  Dir="/var/log/$cProcess"
  ExecM "mkdir -p $Dir"
  ExecM "touch $Dir/named.log"
  ExecM "chown bind $Dir/named.log"

  ExecM "rndc-confgen" "modify named.conf with new key"
  
  #resolv.conf (man chflags)

  #/etc/apparmor.d/usr.sbin.named
}


# ------------------------
clear
case $1 in
    Exec|e)     ExecEx	$2 ;;
    Install)    $1      $2 ;;
    Init)       $1      $2 ;;
    *)		TestEx	;;
esac
