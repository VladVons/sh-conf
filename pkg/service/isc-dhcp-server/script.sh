#!/bin/bash
#--- VladVons@gmail.com


source $DIR_ADMIN/conf/script/system.sh


Clear()
# ------------------------
{
  Log "$0->$FUNCNAME"

  ### clear cache
  rm /var/lib/dhcp/*
  touch /var/lib/dhcp/dhcpd.leases
}


# ------------------------
case $1 in
    Clear)	$1	$2 ;;
esac
