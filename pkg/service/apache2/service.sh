#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


# plugin
# https://addons.mozilla.org/uk/firefox/addon/live-http-headers/

TestEx()
{
  Test

  #ExecM "ls /usr/lib/apache2/modules | sort" "Get all mods"
  
  # https://www.digitalocean.com/community/tutorials/how-to-set-up-mod_security-with-apache-on-debian-ubuntu
  ExecM "apachectl -M | grep security"
}


ExecEx()
# ------------------------
{
  aAction=${1:-"restart"}

  Exec $aAction
  #apachectl graceful
}


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"
  
  # svn via http
  #a2enmod dav
  #a2enmod dav_svn
  #a2enmod dav_fs

  # mods 
  a2enmod rewrite
  a2enmod headers

  # perl
  a2enmod perl

  #a2enmod charset_lite

  # SSL
  a2enmod ssl
  a2ensite default-ssl
}


# ------------------------
clear
case $1 in
    Exec|e)	ExecEx	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		TestEx	;;
esac
