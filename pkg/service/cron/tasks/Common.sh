#!/bin/bash

source $DIR_ADMIN/conf/script/utils.sh


Awstats()
# ------------------------
{
  Log "$0->$FUNCNAME"

  cd $DIR_ADMIN/conf/pkg/service/awstats
  ./script.sh Update
}


MySQLBackupHosting()
# ------------------------
{
  Log "$0->$FUNCNAME"

  cd $DIR_ADMIN/conf/pkg/service/mysql-server
  ./script.sh DumpMask 3w_ DumpLast $gDirHosting/db_backup
}


MySQLBackupArchive()
# ------------------------
{
  Log "$0->$FUNCNAME"

  cd $DIR_ADMIN/conf/pkg/service/mysql-server
  ./script.sh DumpMask "app_|3w_"
}


MySQLBackupExport()
# ------------------------
{
  Log "$0->$FUNCNAME"

  cd $DIR_ADMIN/conf/pkg/service/mysql-server
  ./script.sh DumpExport app_front_office $gHostFriend
}


ConfBackup()
# ------------------------
{
  Log "$0->$FUNCNAME"

  cd $DIR_ADMIN/conf/script
  ./utils.sh ConfBackup
}


EtcBackup()
# ------------------------
{
  Log "$0->$FUNCNAME"

}


Rsync()
# ------------------------
{
  Log "$0->$FUNCNAME"

  cd $DIR_ADMIN/conf/pkg/service/rsync
  ./script.sh soft
  ./script.sh conf
}


Hosting()
# ------------------------
{
  Log "$0->$FUNCNAME"

  #cd $DIR_ADMIN/conf/pkg/service/apache2
  #./script.sh SetPerm
  #./script.sh Backup
}


DiskClearTemp()
# ------------------------
{
  Log "$0->$FUNCNAME"

  echo "Clear temp files"
  DirRemoveOld $gDirSamba/Temp 30
  DirRemoveOld $gDirSamba/Recycle 30
  DirRemoveOld /tmp 30
}


DiskClearBackup()
# ------------------------
{
  Log "$0->$FUNCNAME"

  echo "Clear SQL archive"
  DirRemoveOld $gDirBackupMySQL 7

  echo "Clear 1C archive"
  DirRemoveOld /home/BackUp/1C 90
}


ShutDownEx()
# ------------------------
{
  aWait=$1; aWakeUp="$2";
  Log "$0->$FUNCNAME, $aWait, $aWakeUp"

  # skip power-off one day a week for administrator service purposes
  dow=$(date +%u)
  monday=1
  if [ $dow != $monday ]; then  
    ShutDown $aWait "$aWakeUp"   
  fi;
}



HideBackup()
# ------------------------
{
  aDirSrc=$1; aDirDst="$2";
  Log "$0->$FUNCNAME, $aDirSrc, $aDirDst"

  Day=$(date +%d)
  if [ $Day -eq "01" ]; then
    Part="Month"
  else
    Part="Day"
  fi

  mkdir -p $aDirDst/$Part

  cd $aDirSrc
  #mv -f * $aDirDst/$Part/ # directory not empty
  find . -type d -exec mkdir -p $aDirDst/$Part/{} \;
  find . -type f -exec mv -f {} $aDirDst/$Part/{} \;

  DirRemoveOld $aDirDst/Day 30
  echo "see $aDirDst" > $aDirSrc/readme.txt
}


WavToMp3()
# ------------------------
{
  aDir=$1;
  Log "$0->$FUNCNAME, $aDir"

  Mask="*.wav"
  Sample=12
  Rate=32  
  
  find "$aDir" -type f -iname $Mask | \
  sort | \
  while read File; do
    echo "Converting $File ..."
    FileOut="${File%.wav}.mp3"
    lame --silent --scale 3 --resample $Sample --vbr-new -B $Rate "$File" "$FileOut"
    if [ -r $FileOut ]; then
      rm $File
    fi
  done  
}


Test()
# ------------------------
{
  aMsg=$1;
  Log "$0->$FUNCNAME, $aMsg"
  
  #ShutDownEx 30 "tomorrow 7:30"
  #MySQLBackupArchive
  #Awstats
}


case $1 in
    Test)              $1 $2 $3 $4;;
esac
