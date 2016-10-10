#!/bin/bash
#--- VladVons@gmail.com


source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


#https://www.digitalocean.com/community/tutorials/how-to-use-backuppc-to-create-a-backup-server-on-an-ubuntu-12-04-vps


init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  # Apache
  a2enmod cgi
  a2enmod perl

  # only for LXC container (server side)
  chmod 4755 /bin/ping

  dpkg-reconfigure $cApp

  #KeyToClient

  #lynx http://localhost/backuppc
}


KeyToClient()
{
  Log "$0->$FUNCNAME"

  ClientHost="oster.com.ua"

  # !!! if host name is changed you must regenerate RSA key on server and client

  # ??? . see ./doc/HowTo.txt
  #su -s /bin/bash backuppc
  #su -c "ssh -l root $ClientHost 'mkdir -p /root/.ssh'"
  #su -c "./script.sh AsBackupUser $ClientHost" -s /bin/sh $User
}


InstallEx()
{
  Install

  # perl compression module
  cpan Compress::Zlib
}


# ------------------------
clear
case $1 in
    Exece)    		$1 $2	;;
    Install)		InstallEx	$2 ;;
    Init)		$1 $2	;;
    KeyToClient)	$1 $2	;;
    *)			Test	;;
esac
