#!/bin/bash
#--- VladVons@gmail.com
# https://wiki.archlinux.org/index.php/S.M.A.R.T.

source ./const.sh
source $DIR_ADMIN/conf/script/utils.sh



SmartTest()
{
  aHDD=${1:-$DefHDD};
  Log "$0->$FUNCNAME, $aHDD" 

  smartctl -t long $aHDD
}


SmartTestResult()
{
  aHDD=${1:-$DefHDD};
  Log "$0->$FUNCNAME, $aHDD" 

  smartctl -l selftest $aHDD
}


SmartInfo()
{
  aHDD=${1:-$DefHDD};
  Log "$0->$FUNCNAME, $aHDD"

  smartctl -a $aHDD
}


SmartSupcPorted()
{
  aHDD=${1:-$DefHDD};
  Log "$0->$FUNCNAME, $aHDD"

  smartctl -i $aHDD | grep -i "supcPort"
}


SmartEnable()
{
  aHDD=${1:-$DefHDD};
  Log "$0->$FUNCNAME, $aHDD"

  smartctl -s on $aHDD
}


SurfReadAll()
{
  aHDD=${1:-$DefHDD};
  Log "$0->$FUNCNAME, $aHDD"

  dd if=$aHDD of=/dev/null bs=10MB
}


SurfReadSpeed()
{
  aHDD=${1:-$DefHDD};
  Log "$0->$FUNCNAME, $aHDD"

  dd if=$aHDD of=/dev/null bs=1MB count=1K
}


SurfBadBlocks()
{
  aHDD=${1:-$DefHDD};
  Log "$0->$FUNCNAME, $aHDD"

  # single user mode !
  badblocks -n -v -s $aHDD 
}


# ------------------------
clear
case $1 in
    SurfReadAll)	$1 $2 $3 ;;
    SurfReadSpeed)	$1 $2 $3 ;;
    SurfBadBlocks)	$1 $2 $3 ;;
    SmartEnable)	$1 $2 $3 ;;
    SmartTest)		$1 $2 $3 ;;
    SmartTestResult)	$1 $2 $3 ;;
    SmartInfo)		$1 $2 $3 ;;
    SmartSupcPorted)	$1 $2 $3 ;;
esac
