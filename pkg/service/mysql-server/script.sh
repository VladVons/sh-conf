#!/bin/bash
#--- VladVons@gmail.com


source $DIR_ADMIN/conf/script/system.sh
source ./const.sh
source ./sql.sh

#
# Speedup restore method
#http://vitobotta.com/smarter-faster-backups-restores-mysql-databases-with-mysqldump
gSpeedUp="--opt"
#gSpeedUp="--add-locks --create-options --disable-keys --extended-insert --lock-tables --quick"


ChangeRootPassw()
{
  CheckParam "$0->$FUNCNAME(aPassw='$1')" $# 1 1
  aPassw="$1";
  Log "$0->$FUNCNAME, $aPassw"

  mysqladmin -u root password $aPassw
  #mysqladmin $gAuth password $aPassw
}


DumpUsers()
{
  Log "$0->$FUNCNAME, $aPassw"

  mysql $gAuth --skip-column-names -A -e "SELECT CONCAT('SHOW GRANTS FOR ''',user,'''@''',host,''';') FROM mysql.user WHERE user<>''" | \
  mysql $gAuth --skip-column-names -A | \
  sed 's/$/;/g'
}


Dump()
# ------------------------
{
  aDBName="$1"; aHost=${2:-"localhost"}; aDirDst=${3:-"$gDirBackupMySQL"};
  CheckParam "$0->$FUNCNAME(aDBName='$aDBName', aHost='$aHost', aDirDst='$aDirDst')" $# 1 3
  Log "$0->$FUNCNAME, $aDBName, $aHost, $aDirDst"

  MkDir $aDirDst
  FileName=$aDirDst/$(GetBackupName Host)_${aDBName}.sql.zip
  echo "backup to $FileName"

  # backup and remove DEFINER owners
  mysqldump $gAuth $gSpeedUp --host=$aHost --events --triggers --routines $aDBName | \
     sed -r 's/ DEFINER=`[^`]+`@`[^`]+`//' | \
     zip > $FileName

  # mydumper -u $gMySQLUser -p $gMySQLPassw --database app_front_office
}


DumpMask()
# ------------------------
{
  aMask="$1"; aMode=${2:-"Dump"}; aDirDst=${3:-"$gDirBackupMySQL"};
  CheckParam "$0->$FUNCNAME(aMask='$aMask', aMode='$aMode', aDirDst='$aDirDst')" $# 1 3
  Log "$0->$FUNCNAME, $aMask, $aMode, $aDirDst"

  for DB in $(DbList | egrep $aMask); do
    $aMode $DB localhost $aDirDst
  done
}


DumpAll()
# ------------------------
{
  Log "$0->$FUNCNAME"

  MkDir $gDirBackupMySQL

  FileName=$gDirBackupMySQL/$(GetBackupName Host)_all.sql.zip
  echo "backup to $FileName"

  mysqldump $gAuth --all-databases --events --triggers --routines | \
    sed -r 's/ DEFINER=`[^`]+`@`[^`]+`//' | \
    zip > $FileName
}


DumpExport()
# ------------------------
{
  CheckParam "$0->$FUNCNAME(aDBName='$1', aHost='$2')" $# 2 2
  aDBName="$1"; aHost="$2"
  Log "$0->$FUNCNAME, $aDBName, $aHost"

  Check=$(SQL "SHOW DATABASES" $aHost | grep -c "information_schema")
  if [ $Check == 1 ]; then
    SQL "CREATE DATABASE IF NOT EXISTS $aDBName" $aHost

    mysqldump $gAuth --host=localhost --events --triggers --routines $aDBName | \
      sed -r 's/ DEFINER=`[^`]+`@`[^`]+`//' | \
      mysql $gAuth --host $aHost $aDBName
  fi;
}


DumpImport()
# ------------------------
{
  CheckParam "$0->$FUNCNAME(aDBName='$1', aHost='$2')" $# 2 2
  aDBName="$1"; aHost="$2"
  Log "$0->$FUNCNAME, $aDBName, $aHost"

  mysqldump $gAuth --host=$aHost --events --triggers --routines $aDBName | \
     sed -r 's/ DEFINER=`[^`]+`@`[^`]+`//' | \
     mysql --host=localhost $gAuth $aDBName
}


DbTestDump()
{
  Log "$0->$FUNCNAME"
 
  DbName="app_front_office"
  time Dump $DbName
}


DbTestRestore()
{
  Log "$0->$FUNCNAME"

  DateStart=$(date +"%s")

  DbHost=localhost
  DbName="app_front_office" 
  DbSQL="/Temp/tz20c.sql" 

  SQL "DROP DATABASE IF EXISTS $DbName";  
  SQL "CREATE DATABASE $DbName";
  time SQLFile $DbSQL $DbHost $DbName

  DateEnd=$(date +"%s")
  Diff=$(($DateEnd-$DateStart))
  echo
  echo "$(($Diff / 60))m : $(($Diff % 60))s"
}


DbRepair()
# ----------------------
{
  Log "$0->$FUNCNAME"

  if YesNo "It can takes a long time" 30 0; then
    mysqlcheck $gAuth --all-databases --auto-repair --optimize
  fi;
}


DbUpgrade()
# ----------------------
{
  Log "$0->$FUNCNAME"

  mysql_upgrade $gAuth
}


MyTop()
# ----------------------
{
  Log "$0->$FUNCNAME"

  mytop $gAuth
}


DbOptimize()
{
  SpaceFree=$(df / | awk '{ print $4 }' | tail -1)
  DirSize=$(du -s $gLocation | awk '{ print $1 }')
  SpaceNeed=$(($DirSize * 3))
  if [ $SpaceNeed -gt $SpaceFree ]; then
    echo "No space on disk for this operation !"
    echo "SpaceFree: $SpaceFree, DirSize: $DirSize, SpaceNeed: $SpaceNeed"
    return
  fi;

  if YesNo "Purge MySQL will takes a long time" 30 0; then
    FileDump="/tmp/MySqlDump.sql"

    echo "mysql dump to $FileDump ..."
    mysqldump $gAuth --all-databases --events --triggers --routines | \
      sed -r 's/ DEFINER=`[^`]+`@`[^`]+`//' > $FileDump

    if [ $? -eq 0 ] && [ -d $gLocation ]; then
      $cService stop
      sleep 1 

      echo "Backup mysql directory to $gLocation.bak ..."
      cp -R $gLocation "$gLocation.bak"
      chown -R mysql:mysql "$gLocation.bak"

      $cService start

      for DB in $(DbList); do
        SQL "DROP DATABASE $DB"
      done

      $cService stop
      sleep 1

      echo "removing files ... "
      ##find $gLocation -not -iregex "\./\(mysql\|performance_schema\|information_schema\).*" -delete
      rm $gLocation/*

      $cService start

      echo "restoring from backup $FileDump ..."
      mysql $gAuth < $FileDump
    fi;
  fi;
}


DbCreate()
{
  aDBName="$1";
  Log "$0->$FUNCNAME, $aDBName"

  dbCreate $aDBName
}


# ------------------------
case $1 in
    Dump)       	$1      $2 $3 $4 ;;
    DumpAll)    	$1      $2 ;;
    DumpMask)   	$1      $2 $3 $4 $5 ;;
    DumpExport) 	$1      $2 $3 $4 ;;
    DumpImport) 	$1      $2 $3 $4 ;;
    DumpUsers)		$1      $2 $3 $4 ;;
    DbCreate)   	$1      $2 $3 $4 ;;
    DbList)     	$1      $2 $3 $4 ;;
    DbOptimize)		$1      $2 $3 $4 ;;
    DbRepair)   	$1      $2 $3 $4 ;;
    DbTestDump)   	$1      $2 $3 $4 ;;
    DbTestRestore)   	$1      $2 $3 $4 ;;
    DbUpgrade)  	$1      $2 $3 $4 ;;
    MyTop)      	$1      $2 $3 $4 ;;
    ShowVar)    	$1      $2 $3 $4 ;;
esac
