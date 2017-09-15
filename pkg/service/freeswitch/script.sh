#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


#fs_cli -q
# show registrations
# list_users
# list_users user 2010
# show calls
# sofia status
# sofia status profile internal
# global_getvar
# eval [expression]
# module_exists mod_sofia mod_cdr_sqlite
# reload mod_sofia

# Debug
# sofia profile internal siptrace on
# sofia global siptrace on


Clear()
{
  Log "$0->$FUNCNAME"

  echo > $cLog1
  echo > $cDB_csv

  sqlite3 $cDB_sql "DELETE FROM cdr ;"
  phones="2011|2010|2006|2007|9102|9103|9104|9105|9106|9109|9110|9113"
  #phones="2010|2011"
  find $DirRecord -type f | egrep "_($phones)[_\.]" | xargs rm -f
}


ListUsers()
{
  #SIP auth challenge (REGISTER) on sofia profile 'wan' for [2007@sip.oster.com.ua] from ip 5.58.6.232

  fs_cli -x 'list_users' | awk -F '|' '{ print $1 }' | grep -E -o '[0-9]+' | sort | uniq | \
  while read i; do
    echo -n "$i|" 
  done
}


Filter_From()
{
  aID=$1;
  Log "$0->$FUNCNAME, $aID"

  sqlite3 $cDB_sql "SELECT * FROM cdr WHERE caller_id_number='$aID' ;"
}


Filter_CallCenter()
{
  Log "$0->$FUNCNAME"

  find $DirRecord -type f | egrep '_(5511|5510)_' | grep -E -o '_([0-9]+)\.' | sort | uniq
}


Filter_Calls()
{
  Log "$0->$FUNCNAME"

  sqlite3 $cDB_sql "SELECT caller_id_name, COUNT(*) AS Cnt FROM cdr GROUP BY caller_id_name ORDER BY Cnt DESC LIMIT 25;"
}


Filter_Ratio()
{
  aID=$1;
  Log "$0->$FUNCNAME, $aID"

  #sqlite3 $cDB_sql \
    #"SELECT COUNT(*) AS CntIn  FROM cdr WHERE caller_id_name   LIKE '%$aID'
     #UNION ALL 
     #SELECT COUNT(*) AS CntOut FROM cdr WHERE destination_number LIKE '%$aID';"

  sqlite3 $cDB_sql \
    "SELECT
     (SELECT COUNT(*) FROM cdr WHERE caller_id_name LIKE '%$aID')     AS CntIn,
     (SELECT COUNT(*) FROM cdr WHERE destination_number LIKE '%$aID') AS CntOut"
}


Status()
{
  ExecM "fs_cli -x 'sofia status'"
  ExecM "fs_cli -x 'show registrations'"
  #ExecM "fs_cli -x 'show calls'"
  #ExecM "fs_cli -x 'show codec'"
  #ExecM "fs_cli -x 'show modules'"
  #ExecM "fs_cli -x 'sofia status profile internal'"
  #ExecM "fs_cli -x 'sofia status profile external'"
  #ExecM "fs_cli -x 'sofia status profile lan' | grep WS-BIND-URL"

  #ExecM "ls -1 $DirMod | sort"
}


ModList()
{
  ls -1 /usr/lib/freeswitch/mod | sort
}


Reload()
{
  Log "$0->$FUNCNAME"

  ExecM "fs_cli -x 'reloadxml'"
  ExecM "fs_cli -x 'reload mod_sofia'"

  Status
}

# ------------------------
case $1 in
    Clear)		$1	$2 ;;
    Filter_CallCenter)	$1	$2 ;;
    Filter_Calls)	$1	$2 ;;
    Filter_From)	$1	$2 ;;
    Filter_Ratio)	$1	$2 ;;
    ListUsers)		$1	$2 ;;
    Reload)		$1	$2 ;;
    Status)		$1	$2 ;;
esac
