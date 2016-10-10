#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/system.sh


Clear()
{
  Log "$0->$FUNCNAME"

  rm -R /var/cache/awstats/*
  rm /usr/lib/cgi-bin/awstats*.txt
  rm /var/lib/awstats/awstats*.txt
  #rm /var/log/apache2/3w_*_access.log

  Update
}


Update()
# ------------------------
{
  # The best way of working is to use the Apache "combined" log format 

  # see /etc/cron.d/awstats
  /usr/share/awstats/tools/update.sh
  /usr/share/awstats/tools/buildstatic.sh
}


Update_old()
# ------------------------
{
  
  echo "Dir: $gConfDir"  
  ls $gConfDir | grep ".conf" | sed -e 's/awstats.//' | sed -e 's/.conf//' |\
  while read i; do
    echo; echo ${i}
    $gExec -config="${i}"
  done
}  


# ------------------------
case $1 in
    Clear)	$1		$2 ;;
    Update)	$1		$2 ;;
esac
