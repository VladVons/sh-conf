#!/bin/bash
#--- VladVons@gmail.com


source $DIR_ADMIN/conf/script/system.sh


SendMail()
# ------------------------
{
  Log "$0->$FUNCNAME"

  echo "
To: $gAdminMail
From: OlegVons@mail.ru
Subject: Test via SSMTP 1
This is a test for sending" | ssmtp -v $gAdminMail

  sleep 1
  echo "Test via SSMTP 2" | ssmtp -v -s "Subj-Test via SSMTP 2" $gAdminMail

  sleep 1
  echo "Test via MAIL" | mail -s "Subj-Test via MAIL" $gAdminMail

  sleep 1
  $DIR_ADMIN/conf/pkg/service/php5/script/TestMail.php
}


case $1 in
    SendMail)	$1	$2 ;;
esac
