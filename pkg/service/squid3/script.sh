#!/bin/bash
#--- VladVons@gmail.com


source $DIR_ADMIN/conf/script/system.sh


GenKey()
# ------------------------
#http://shirker.blog.com/2011/11/10/generate-ssl-certificate-for-squid 
{
  Log "$0->$FUNCNAME"
 
  Dir='/usr/local/etc/squid/conf/ssl'
  mkdir -p $Dir
  cd $Dir

  #openssl genrsa -des3 -out squid.key 1024
  #openssl req -new -key squid.key -out squid.csr
  #cp squid.key squid.key.org
  #openssl rsa -in squid.key.org -out squid.key
  #openssl x509 -req -days 365 -in squid.csr -signkey squid.key -out squid.crt

  openssl genrsa -out squid.key
  openssl req -new -key squid.key -out squid.csr
  openssl x509 -req -days 3650 -in squid.csr -signkey squid.key -out squid.pem
}


AddUser()
# ------------------------
{
  aUser=$1; aPasswd=$2;
  Log "$0->$FUNCNAME, $aUser, $aPasswd"

  Var="/usr/local/etc/squid/conf/Users"
  htpasswd -b $Var/Passwd $aUser $aPasswd
  if [ ! "$(grep $aUser ${Var}/Users.lst)" ]; then
    echo $aUser >> ${Var}/Users.lst 
  fi
}


# ------------------------
case $1 in
    AddUser)	$1	$2 ;;
    GenKey)	$1	$2 ;;
esac
