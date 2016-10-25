#!/bin/bash
#--- VladVons@gmail.com
# https://wiki.mikejung.biz/Sysbench

source $DIR_ADMIN/conf/script/system.sh


CPU()
{
  sysbench --test=cpu --cpu-max-prime=20000 run
}


FileIO()
{
  Size="16G"

  sysbench --test=fileio --file-total-size=$Size prepare
  sysbench --test=fileio --file-total-size=$Size --file-test-mode=rndrw --max-time=300 --max-requests=0 run
  sysbench --test=fileio --file-total-size=$Size cleanup
}


Mem()
{
  sysbench --test=memory --num-threads=4 run
}


RunMySQL()
{
  db="app_test"
  gAuth="--user=$gMySQLUser --password=$gMySQLPassw"

  SQL="CREATE DATABASE IF NOT EXISTS $db"
  ExecM "mysql $gAuth --disable-column-names --batch --execute='$SQL'"

  ExecM "sysbench --test=oltp --oltp-table-size=1000000 --mysql-db=$db --mysql-user=$gMySQLUser --mysql-password=$gMySQLPassw prepare"
  #ExecM "sysbench --test=oltp --mysql-db=$db --mysql-user=$gMySQLUser --mysql-password=$gMySQLPassw --max-time=10 --oltp-read-only=on --max-requests=0 --num-threads=2 run"
  ExecM "sysbench --test=oltp --mysql-db=$db --mysql-user=$gMySQLUser --mysql-password=$gMySQLPassw cleanup"
}

MySQL()
{
  time RunMySQL
}

clear
sysbench --version

# ------------------------
case $1 in
    CPU)    $1 $2 ;;
    FileIO) $1 $2 ;;
    Mem)    $1 $2 ;;
    MySQL)  $1 $2 ;;
esac

