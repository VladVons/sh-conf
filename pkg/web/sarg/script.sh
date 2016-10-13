#!/bin/bash
#--- VladVons@gmail.com

source $DIR_ADMIN/conf/script/utils.sh


GetBackDate()
# ------------------------
{
  aDays=${1:-1};

  date -d "-${aDays} day" +'%d/%m/%Y'
}


OneDay()
# ------------------------
{
  aDate=$1;
  Log "$0->$FUNCNAME, $aDate"

  if [ ! "$aDate" ]; then
    aDate=$(date "+%d/%m/%Y")
  fi
 
  sarg -d "$aDate-$aDate"
}


LastDays()
# ------------------------
{
  aDays=${1:-1};
  Log "$0->$FUNCNAME, $aDays"
 
  sarg -d $(GetBackDate $aDays)-$(GetBackDate 0)
}


LastMonth()
# ------------------------
{
  Log "$0->$FUNCNAME"

  LastDays 30
}


# ------------------------
case $1 in
    OneDay)	$1	$2 ;;
    LastMonth)	$1	$2 ;;
esac
