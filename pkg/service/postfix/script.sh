#!/bin/bash
#--- VladVons@gmail.com


source $DIR_ADMIN/conf/script/system.sh


Backup()
# ------------------------
{
  Log "$0->$FUNCNAME"
  
  ArchName="$(uname -n)_$(uname -s)_$(date "+%y%m%d_%H%M")"_$(basename $(pwd))
  echo "Archive $ArchName ..."
  zip -r "$ArchName.zip" /var/spool/mail /var/db/mysql/app_postfix
}


SendMail()
{
  Log "$0->$FUNCNAME"

  echo "mode 1"
  echo "Test via MAIL" | mail -s "Subj-Test via MAIL" $gAdminMail

  sleep 1
  echo "mode 2"
  $DIR_ADMIN/conf/pkg/service/php5/script/TestMail.php
}


RedirectMail()
{
  #echo $gAdminMail > /root/.forward
  #or  
  echo "root: $gAdminMail" >> /etc/aliases && newaliases
}


Reconfig()
{
  newaliases
  dpkg-reconfigure $cApp
}


# ------------------------
case $1 in
    Backup)		$1 $2 ;;
    SendMail)		$1 $2 ;;
    RedirectMail)	$1 $2 ;;
    Reconfig)		$1 $2 ;;
esac
