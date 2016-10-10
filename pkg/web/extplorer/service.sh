#!/bin/bash
#--- VladVons@gmail.com


source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


InstallEx()
# ------------------------
{
  Log "$0->$FUNCNAME"

  DirDst="/var/www/lib/$cApp" 
  File="eXtplorer_2.1.9.zip"
  Url="http://extplorer.net/attachments/download/68/$File"

  wget $Url
  unzip $File -d $DirDst
  chown -R www-data $DirDst
  rm $File

  cp file/extplorer.conf /etc/apache2/conf-enabled/
  apachectl graceful

  # url: http://localhost/extpl
  # user: admin
  # passw: admin
}


# ------------------------
clear
case $1 in
    Install)    InstallEx $2 ;;
    Init)       $1      $2 ;;
    *)		Test	;;
esac
