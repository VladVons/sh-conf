#!/bin/bash


Sync()
{
  apt-get update
  apt-get install --yes --no-install-recommends mc rsync

  mkdir -p /admin/conf
  rsync --recursive --links --times --update --delete tr24.oster.com.ua::AdminFull /admin/conf

  File="/etc/environment"
  if [ -z $(grep "DIR_ADMIN" $File) ]; then
    Var="DIR_ADMIN=/admin"
    echo $Var >> $File
    export $Var
  fi
}


Install()
{
  source ./script/utils.sh

  #File="fileserver.lst"
  #File="proxmox.lst"
  #File="router.lst"
  #File="xubuntu.lst"

  PkgListInst $File
}


Installed()
{
  source ./script/utils.sh
  PkgInstalled
}


Mount()
{
  Dir="/mnt/smb/tr24"

  mkdir -p $Dir
  mount -t cifs //192.168.2.1/temp $Dir -o user=guest -o password=guest
}


Sync
#Install
#Installed
#Mount
