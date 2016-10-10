#!/bin/bash
#--- VladVons@gmail.com


source $DIR_ADMIN/conf/script/system.sh


SSL_KeyGen()
# ------------------------
{
  Log "$0->$FUNCNAME"

  Init
 
  EchoFile="$WorkDir/echo.sh"
  echo "Remember and place 'pass phrase' into $EchoFile !"
  echo "Press a key..."
  echo

  DirKey="$WorkDir/Keys"
  openssl genrsa -des3 -rand /dev/random -out $DirKey/server.key 1024
  openssl rsa -in $DirKey/server.key -out $DirKey/server.pem
  openssl req -new -key $DirKey/server.key -out $DirKey/server.csr
  openssl x509 -req -days 365 -in $DirKey/server.csr -signkey $DirKey/server.key -out $DirKey/server.crt
}


# ------------------------
case $1 in
    SSL_KeyGen)	$1	$2 ;;
esac
