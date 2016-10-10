#!/bin/bash


AddPpa()
{
  Distr=$(lsb_release --id --short)
  if [ "$Distr" = "Debian" ]; then
    Pkg="zabbix-release_3.0-1+jessie_all.deb"
    Url="http://repo.zabbix.com/zabbix/3.0/debian/pool/main/z/zabbix-release/$Pkg"
  else
    Pkg="zabbix-release_3.0-1+trusty_all.deb"
    Url="http://repo.zabbix.com/zabbix/3.0/ubuntu/pool/main/z/zabbix-release/$Pkg"
  fi

  wget $Url
  dpkg -i $Pkg
  apt-get update
  rm $Pkg
}
