#!/bin/bash
# Const.sh 
# VladVons@gmail.com
# created 01-11-14
#---

# Version
gVerInfo="1.14, 2016-10-14, VladVons@gmail.com"


# Root
gDirConfDef=/admin/conf
gDirConf=$DIR_ADMIN/conf
gDirMan=$DIR_ADMIN/man
gDirHost=$DIR_ADMIN/host
gDirScript=$DIR_ADMIN/conf/script
gDirPkg=$DIR_ADMIN/conf/pkg
gDirPkgList=$DIR_ADMIN/conf/pkg/list

#
gDirEtc="/etc"
gDirD="$gDirEtc/init.d"
gUser3w="www-data"

# BackUp
gDirBackup=$DIR_ADMIN/backup
gDirBackupMySQL=$gDirBackup/MySQL
gDirBackupPostgres=$gDirBackup/Postgres
gDirBackupConf=$gDirBackup/conf
gDirBackupSvn=$gDirBackup/svn
gDirBackupPkg=$gDirBackup/pkg
gDirBackupHosting=$gDirBackup/Hosting

gFileLog=$DIR_ADMIN/conf.log
gFileHost=$gDirHost/host.conf
gFileSysLog="/var/log/syslog"

gExclArch="_inf"
gHostFriendPassw="20160101"

# Network
gWorldDNS="8.8.8.8"
gVpnServIP="tr24.oster.com.ua"
#gIntNetBase=$(echo $gIntNet | sed -r 's|.0/24||gI')


CheckEnv()
{
  if [ -z "$DIR_ADMIN" ]; then
    DIR_ADMIN=$gDirConfDef

    File="/etc/environment"
    if [ -z $(grep "DIR_ADMIN" $File) ]; then
      Var="DIR_ADMIN=/admin"
      echo $Var >> $File
      export $Var

      echo "Environment variable 'DIR_ADMIN' is undefined."
      echo "DIR_ADMIN=/admin added to $File. Need reboot"
      echo "press ENTER to force RSYNC or Ctrl-C to exit"
      read

      exit
      mkdir -p $DIR_ADMIN/host
      touch $DIR_ADMIN/host/host.conf
      rsync --verbose --progress --recursive --compress --links --times --delete tr24.oster.com.ua::AdminFull /admin/conf
    fi;

    exit 0;
  fi;

  # include host constants and overwrite existance
  if [ -r $gFileHost ]; then
    source $gFileHost
  #else
    #echo "File not found $gFileHost"
    #exit 0;
  fi;
}

CheckEnv
