#!/bin/bash
#--- VladVons@gmail.com


. $DIR_ADMIN/conf/System.sh
. ./_const.sh

#
# Speedup restore method
#http://vitobotta.com/smarter-faster-backups-restores-mysql-databases-with-mysqldump
gSpeedUp="--opt"
#gSpeedUp="--add-locks --create-options --disable-keys --extended-insert --lock-tables --quick"



SQLFile()
# ----------------------
{
  CheckParam "$0->$FUNCNAME(aFile='$1', aHost='$2', aDbName='$3')" $# 1 3
  aFile=$1; aHost=${2:-"localhost"}; aDbName=$3;
  Log "$0->$FUNCNAME, $aFile, $aHost, $aDbName"

  if [ $# == 3 ]; then
    mysql $gAuth --host="$aHost" --database=$aDbName < $aFile
  else
    mysql $gAuth --host="$aHost" < $aFile
  fi;
} 


SQL()
# ----------------------
{
  CheckParam "$0->$FUNCNAME(aSQL='$1', aHost='$2')" $# 1 2
  aSQL="$1"; aHost=${2:-"localhost"};
  Log "$0->$FUNCNAME, $aSQL, $aHost"

  mysql $gAuth --host="$aHost" --disable-column-names --batch --execute="$aSQL"
}



ChangeRootPassw()
{
  CheckParam "$0->$FUNCNAME(aPassw='$1')" $# 1 1
  aPassw="$1";
  Log "$0->$FUNCNAME, $aPassw"

  mysqladmin $gAuth password $aPassw
}


Dump()
# ------------------------
{
  CheckParam "$0->$FUNCNAME(aDBName='$1')" $# 1 2
  aDBName="$1"; aHost=${2:-"localhost"};
  Log "$0->$FUNCNAME, $aDBName, $aHost"

  MkDir $gDirBackupMySQL
  FileName=$gDirBackupMySQL/$(GetBackupName Host)_${aDBName}.sql.zip
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
  CheckParam "$0->$FUNCNAME(aMask='$1')" $# 1 1
  aMask="$1";
  Log "$0->$FUNCNAME, $aMask"

  for i in $(DbList | egrep $aMask); do
    Dump "$i"
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


DbList()
# ----------------------
{
  SQL "SHOW DATABASES;" | egrep -v "(information_schema|mysql|performance_schema)"
}


DbDelete()
# ----------------------
{
  CheckParam "$0->$FUNCNAME(aDBName='$1')" $# 1 1
  aDBName="$1";
  Log "$0->$FUNCNAME, $aDBName"

  SQL "DROP DATABASE $aDBName";
}


DbCreate()
# ----------------------
{
  CheckParam "$0->$FUNCNAME(aDBName='$1')" $# 3 3
  aDBName="$1"; aDBUserName="$2"; aDBUserPassw="$3"
  Log "$0->$FUNCNAME, $aDBName, $aDBUserName, $aDBUserPassw"

  SQL "CREATE DATABASE IF NOT EXISTS $aDBName; \
       GRANT ALL PRIVILEGES ON ${aDBName}.* TO '${aDBUserName}'@'localhost' IDENTIFIED BY '${aDBUserPassw}' WITH GRANT OPTION;"
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


ShowVar()
# ----------------------
{
  Log "$0->$FUNCNAME"

  SQL "SHOW VARIABLES;"
}


MyTop()
# ----------------------
{
  Log "$0->$FUNCNAME"

  mytop $gAuth
}


Purge()
{
  FileDump="/tmp/MySqlDump.sql"

  if YesNo "Purge MySQL will takes a long time" 30 0; then
    #echo "Repairing ..."
    #mysqlcheck $gAuth --all-databases --auto-repair --optimize

    echo "backuping DB to $FileDump ..."
    mysqldump $gAuth --all-databases --events --triggers --routines --opt > $FileDump
    if [ $? -eq 0 ] && [ -d $gLocation ]; then
      $Service stop

      cd $gLocation
      #ls -l -s --group-directories-first
      echo "removing files ... "
      find . -not -iregex "\./\(mysql\|anotherdir\).*" -delete
      #find . | grep -v mysql | xargs rm --force
      #ls -l -s --group-directories-first 

      $Service start

      echo "restoring from backup $FileDump ..."
      mysql $gAuth < $FileDump
    fi;
  fi;
}


# ------------------------
case $1 in
    Dump)       	$1      $2 $3 $4 ;;
    DumpAll)    	$1      $2 ;;
    DumpMask)   	$1      $2 $3 $4 ;;
    DumpExport) 	$1      $2 $3 $4 ;;
    DumpImport) 	$1      $2 $3 $4 ;;
    DbCreate)   	$1      $2 $3 $4 ;;
    DbList)     	$1      $2 $3 $4 ;;
    DbRepair)   	$1      $2 $3 $4 ;;
    DbTestDump)   	$1      $2 $3 $4 ;;
    DbTestRestore)   	$1      $2 $3 $4 ;;
    DbUpgrade)  	$1      $2 $3 $4 ;;
    MyTop)      	$1      $2 $3 $4 ;;
    ShowVar)    	$1      $2 $3 $4 ;;
    Purge)		$1      $2 $3 $4 ;;
esac
