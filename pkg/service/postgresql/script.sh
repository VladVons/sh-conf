#!/bin/bash
#--- VladVons@gmail.com


. $DIR_ADMIN/conf/script/system.sh


DbList()
# ----------------------
{
  SQL "SHOW DATABASES;"
}


Dump()
# ------------------------
{
  CheckParam "$0->$FUNCNAME(aDBName='$1')" $# 1 1
  aDBName="$1";
  Log "$0->$FUNCNAME, $aDBName"

  MkDir $gDirBackupPostgres
  FileName=$gDirBackupPostgres/$(GetBackupName Host)_${aDBName}.sql.zip
  echo "backup to $FileName"

  pg_dump $aDBName | \
    zip > $FileName
}


DumpMask()
# ------------------------
{
  CheckParam "$0->$FUNCNAME(aMask='$1')" $# 1 1
  aMask="$1";
  Log "$0->$FUNCNAME, $aMask"

  for i in $(DbList | grep $aMask); do
    Dump "$i"
  done
}


DumpAll()
# ------------------------
{
  Log "$0->$FUNCNAME"

  MkDir $gDirBackupPostgres

  FileName=$gDirBackupPostgres/$(GetBackupName Host)_all.sql.zip
  echo "backup to $FileName"

  pg_dumpall | \
    zip > $FileName
}


# ------------------------
case $1 in
    Dump)	$1	$2 ;;
    DumpAll)    $1      $2 ;;
    DumpMask)	$1	$2 ;;
    DbCreate)	$1	$2 ;;
    DbRepair)   $1	$2 ;;
    DbUpgrade)  $1	$2 ;;
esac
