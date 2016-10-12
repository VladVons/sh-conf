#!/bin/bash
#--- VladVons@gmail.com
# https://wiki.mikejung.biz/Sysbench

source $DIR_ADMIN/conf/script/system.sh


cpu()
{
  sysbench --test=cpu --cpu-max-prime=20000 run
}


fileio()
{
  Size="16G"

  sysbench --test=fileio --file-total-size=$Size prepare
  sysbench --test=fileio --file-total-size=$Size --file-test-mode=rndrw --max-time=300 --max-requests=0 run
  sysbench --test=fileio --file-total-size=$Size cleanup
}


mem()
{
  sysbench --test=memory --num-threads=4 run
}


mysql()
{
  db="app_test"
  gAuth="--user=$gMySQLUser --password=$gMySQLPassw"
  SQL="CREATE DATABASE IF NOT EXISTS $db"

  mysql $gAuth --disable-column-names --batch --execute="$SQL"
  sysbench --test=oltp --oltp-table-size=100000 --mysql-db=$db --mysql-user=$gMySQLUser --mysql-password=$gMySQLPassw prepare

  sysbench --test=oltp --mysql-db=$db --mysql-user=$gMySQLUser --mysql-password==$gMySQLPassw cleanup
}


clear
sysbench --version

# ------------------------
case $1 in
    cpu)    $1 $2 ;;
    fileio) $1 $2 ;;
    mem)    $1 $2 ;;
    mysql)  $1 $2 ;;
esac

