#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/system.sh
source $DIR_ADMIN/conf/pkg/service/mysql-server/sql.sh


gMySQLUser=root
gMySQLPassw=19710819
gAuth="--user=$gMySQLUser --password=$gMySQLPassw"


ResetAdminPassw()
{
  Log "$0->$FUNCNAME"

  grafana-cli admin reset-admin-password --homepath "/usr/share/grafana" "NewPassw"
}

CloneDB()
{
  CheckParam "$0->$FUNCNAME(DBSrc=$1; aDBDst=$2; aDBUser=$3; aDBPassw=$4;)" $# 4 4
  aDBSrc=$1; aDBDst=$2; aDBUser=$3; aDBPassw=$4;

  SQL "CREATE DATABASE IF NOT EXISTS $aDBDst;"
  SQL "GRANT ALL PRIVILEGES ON ${aDBDst}.* TO '${aDBUser}'@'localhost' IDENTIFIED BY '${aDBPassw}' WITH GRANT OPTION;"
  SQL "GRANT ALL PRIVILEGES ON ${aDBDst}.* TO '${aDBUser}'@'10.10.%.%' IDENTIFIED BY '${aDBPassw}' WITH GRANT OPTION;"

  mysqldump $gAuth --no-data --events --triggers --routines $aDBSrc |\
     sed -r 's/ DEFINER=`[^`]+`@`[^`]+`//'  |\
  mysql $gAuth $aDBDst
}


#./script.sh CloneDB app_grafana6 app_grafana7 grafana7 graf20197
case $1 in
    CloneDB)    CloneDB $2 $3 $4 $5;;
esac
