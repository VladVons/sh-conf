#!/bin/bash

source $DIR_ADMIN/conf/script/utils.sh


Exec()
{
  Log "$0->$FUNCNAME"

  DF=$(df -h /)

  # squid web proxy
  service squid3 stop
  rm /var/spool/squid3/*

  # squid analyzer
  rm /var/lib/sarg/*

  # collectd
  service collectd stop
  rm /var/lib/collectd/rrd/*

  # freeswetch
  service freeswetch stop
  rm /var/lib/freeswitch/recordings/*

  # apt-cacher-ng proxy
  service apt-cacher-ng stop
  rm /var/cache/apt-cacher-ng/

  # backuppc incremental
  rm /var/lib/backuppc/pc/*

  # torrent
  service transmission-daemon stop
  rm /var/lib/transmission-daemon/downloads/*

  # package
  PkgUpdate
  rm /var/lib/apt/lists/*

  LogClear

  echo $DF
  df -h /
}

#Exec
