#!/bin/bash
#--- VladVons@gmail.com

source $DIR_ADMIN/conf/script/utils.sh


MailTo()
{
  aMailTo=$1; aSubj=$2; aBody=$3;
  Log "$0->$FUNCNAME, $aMailTo, $aSubj, $aBody"

  echo -e "$aBody" | mail -s "$aSubj" $aMailTo
}


DelOldArch()
{
  aDir=$1; aDays=$2;
  Log "$0->$FUNCNAME, $aDir, $aDays"

  # disable delete files in pure-ftpd 
  # echo "yes" > /etc/pure-ftpd/conf/KeepAllFiles

  find -L $aDir -type f -name *.7z -mtime +${aDays} -delete
  find -L $aDir -type d -empty -delete
}


CheckLastArch()
{
    aDir=$1; aDays=$2;
    Log "$0->$FUNCNAME, $aDir, $aDays"

    Last=$(find -L $aDir -type f -name *.7z -mtime -${aDays} | tail -n1)
    echo "Test: $aDir, $Last"

    # get User, Passwd 
    source /home/user.conf
    source $aDir/user.conf
    #echo "User:$User, Passw:$Passw, MailTo:$MailTo, PasswArch:$PasswArch"

    if [ -z "$Last" ]; then
        Subject="Err:No backup, Host:$(hostname), User:$User"
        Files=$(find -L $aDir -type f | sort)
        MailTo $MailTo "$Subject" "$Files"
    else
        Size=$(stat -c%s $Last)
        if [ $Size -lt 10000 ]; then
            Subject="Err:Bad archive length $Size. Host:$(hostname), User:$User"
            MailTo $MailTo "$Subject" "File:$Last"
        else
            7z t -p$PasswArch $Last 2>&1 > /dev/null
            if [ $? -ne 0 ]; then
                Subject="Err:Bad archive CRC, Host:$(hostname), User:$User"
                MailTo $MailTo "$Subject" "File:$Last\nDir:$aDir"
            fi;
        fi;
    fi;
}


CheckDir()
{
  aDir=$1; aDays=$2;
  Log "$0->$FUNCNAME, $aDir, $aDays"

  find $aDir -maxdepth 1 -type d | sort | \
  while read Dir; do
    CheckLastArch $Dir $aDays
  done
}


CheckDirList()
{
  aFile=$1; aDays=$2;
  Log "$0->$FUNCNAME, $aFile, $aDays"

  grep -v '^$\|^\s*\#' $aFile | \
  while read Dir; do
    CheckLastArch $Dir $aDays
  done
}


Install()
{
  apt install p7zip-full mailutils
} 


#---
clear

DelOldArch  "/home/ftp" 4

#CheckDir    "/home/ftp" 1
#find /home -maxdepth 1 -type d | sort > Archive.lst
CheckDirList "/home/Archive.lst" 1
