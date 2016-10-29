#!/bin/bash


Init()
{
  apt-get update
  apt-get install --yes --no-install-recommends mc rsync

  mkdir -p /admin/conf
  rsync --update --recursive --links tr24.oster.com.ua::AdminFull /admin/conf

  File="/etc/environment"
  if [ -z $(grep "DIR_ADMIN" $File) ]; then
    Var="DIR_ADMIN=/admin"
    echo $Var >> $File
    export $Var
  fi
}


Inst()
{
  source ./script/utils.sh
  PkgListInst lxc-router.lst
}

#Init
Inst

