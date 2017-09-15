#!/bin/bash
#--- VladVons@gmail.com


source $DIR_ADMIN/conf/script/system.sh

gAuth="--user=$gMySQLUser --password=$gMySQLPassw"


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


SQLFileGz()
# ----------------------
{
  aFile=$1; aDbName=$2;
  Log "$0->$FUNCNAME, $aFile, $aDbName"

  zcat $aFile | mysql $gAuth --verbose $aDbName
}


SQL()
# ----------------------
{
  aSQL="$1"; aHost=${2:-"localhost"};

  mysql $gAuth --host=$aHost --disable-column-names --batch --execute="$aSQL"
}


DbSQL()
# ----------------------
{
  aDB="$1"; aSQL="$2"; aHost=${3:-"localhost"};

  mysql $gAuth --host=$aHost --database=$aDB --disable-column-names --batch --execute="$aSQL"
}



dbCreate()
# ----------------------
{
  aDBName="$1";
  Log "$0->$FUNCNAME, $aDBName"

  SQL "CREATE DATABASE IF NOT EXISTS $aDBName;"
}


dbGrant()
# ----------------------
{
  aDBName="$1"; aDBUserName="$2"; aDBUserPassw="$3"
  Log "$0->$FUNCNAME, $aDBName, $aDBUserName, $aDBUserPassw"

  SQL "GRANT ALL PRIVILEGES ON ${aDBName}.* TO '${aDBUserName}'@'localhost' IDENTIFIED BY '${aDBUserPassw}' WITH GRANT OPTION;"
  SQL "flush privileges;"
}


dbCreateGrant()
# ----------------------
{
  aDBName="$1"; aDBUserName="$2"; aDBUserPassw="$3"

  dbCreate $aDBName
  dbGrant  $aDBName $aDBUserName $aDBUserPassw
}


DbDelete()
# ----------------------
{
  aDBName="$1";
  Log "$0->$FUNCNAME, $aDBName"

  SQL "DROP DATABASE $aDBName;"
}


DbDeleteTables()
# ----------------------
{
  aDBName="$1";
  Log "$0->$FUNCNAME, $aDBName"

  Tables=$(DbSQL $aDBName "SHOW TABLES;")
  for Table in $Tables
  do
    #echo "Deleting $Table from $aDBName"
    DbSQL $aDBName "DROP TABLE $Table;"
  done
}


DbList()
# ----------------------
{
  SQL "SHOW DATABASES;" | egrep -v "(information_schema|mysql|performance_schema)"
}


dbShowVar()
# ----------------------
{
  Log "$0->$FUNCNAME"

  SQL "SHOW VARIABLES;"
}

