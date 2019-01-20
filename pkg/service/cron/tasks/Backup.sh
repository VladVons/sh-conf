#!/bin/bash

source $DIR_ADMIN/conf/script/utils.sh



MailTo()
{
  aSubj=$1; aBody=$2;
  Log "$0->$FUNCNAME, $aSubj, $aBody"

  echo "$aBody" | mail -s "$aSubj" "VladVons@gmail.com"
}


DelOldArch()
{
  aDir=$1; aDays=$2;
  Log "$0->$FUNCNAME, $aDir, $aDays"

  # disable delete files in pure-ftpd 
  # echo "yes" > /etc/pure-ftpd/conf/KeepAllFiles

  find -L $aDir -type f -name *.7z -mtime +${aDays} -delete
  find $aDir -type d -empty -delete
}


CheckLastArch()
{
  aDir=$1; aDays=$2;
  Log "$0->$FUNCNAME, $aDir, $aDays"

  ArchPassw="1c20090526"

  ls $aDir | sort | \
  while read Dir; do
    Path="$aDir/$Dir"
    Last=$(find -L $Path -type f -name *.7z -mtime -${aDays} | tail -n1)
    if [ -z "$Last" ]; then
      Subject="Error: No backup in $(hostname):${Path}"
      Files=$(find -L $Path -type f | sort)
      MailTo "$Subject" "$Files"
    else
      echo "test $Last"

      Size=$(stat -c%s $Last)
      if [ $Size -lt 10000 ]; then
        Subject="Error: Bad archive length $Size $(hostname):${Path}"
        MailTo "$Subject" "$Last"
      else
        7z t -p$ArchPassw $Last 2>&1 > /dev/null
        if [ $? -ne 0 ]; then
          Subject="Error: Bad archive CRC $(hostname):${Path}"
          MailTo "$Subject" "$Last"
        fi;
      fi;
    fi;
  done
}


clear
DelOldArch    "/home/ftp" 4
CheckLastArch "/home/ftp" 1
