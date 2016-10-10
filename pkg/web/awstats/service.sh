#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  # http://oster.com.ua/awstats/awstats.pl

  cp -s /etc/apache2/conf-available/awstats.conf /etc/apache2/conf-enabled

  htpasswd -c /etc/awstats/htpasswd admin
  a2enmod cgi
  apachectl graceful


  # Error: Couldn't open server log file "/var/log/apache2/3w_ryshto-bud.com.ua_access.log"
  # /etc/cron.d/awstats. Instead of www-data run from root 
  service cron restart 
}


# ------------------------
clear
case $1 in
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		Test	;;
esac
