#!/bin/bash
# Common.sh
#--- VladVons@gmail.com

source $DIR_ADMIN/conf/script/const.sh


Version()
{
  echo "Ver $gVerInfo"
}


Log()
# Write message to file and show to screen 
# IN: aMsg
# ------------------------
{
  aMsg="$1"; aShow=${2:-1};

  Msg="$(date +%Y-%m-%d-%a), $(date +%H:%M:%S), $(id -u -n), $aMsg"
  echo "$Msg" >> $gFileLog

  if [ $aShow = 1 ]; then
    echo "$Msg"
  fi
}


Wait()
# Wait for keyboartd stroke
# ------------------------
{
  aMsg="$1"; aTimeOut=${2:-600};

  if [ $# = 0 ]; then
    aMsg="Press a key ..."
  else
    aMsg="-= $aMsg =- Press a key ..."
  fi

  echo
  read -t $aTimeOut -p "$aMsg"
}


YesNo()
# Wait for keyboartd stroke Y or N
# Default Timeout=60sec, Result=1 (no)
# ------------------------
{
  CheckParam "$0->$FUNCNAME(aMsg='$1',aTimeOut='$2',aResult='$3')" $# 1 3
  aMsg="$1"; aTimeOut=${2:-600}; aResult=${3:-1};

  if [ $aTimeOut != 600 ]; then
   echo "timeout: $aTimeOut, result: $aResult"
  fi;

  while true; do
    read -t $aTimeOut -p "$1 (y/n): " KeyYN
      case $KeyYN in
        [Yy] ) return 0 ;;
        [Nn] ) return 1 ;;
        ''   ) return $aResult ;;
        *    ) echo "answer Y or N";;
      esac
  done
}


ExecM()
# Execute and show message
#-------------------------
{
  aExec="$1"; aMsg="$2";

  echo
  Log "$FUNCNAME, $aExec, $aMsg"
  eval "$aExec"
}


ExecMW()
# Execute and show message and wait
#-------------------------
{
  aExec="$1"; aMsg="$2";

  ExecM "$aExec" "$aMsg"
  Wait
}


Help()
# Show help
# IN: aMsg, aExitCode
# ------------------------
{
  aMsg="$1"; aExitCode="$2";

  echo "$0->$aMsg"
  echo "Sys handler ver $gVerInfo"
  echo "Usage: Handler [Command [Parameters...]]"
  #echo "Commands are:"
  #cat $0 | tail -25

  exit $aExitCode
}


CheckParam()
# Check parameters quantity bound.
# IN: aCaller, aArgC, aMin, aMax
# ------------------------
{
  aCaller="$0->$1"; aArgC=$2; aMin=$3; aMax=$4; aShow=${5:-1};

  Msg="$aCaller(min $aMin, max $aMax)"
  Log "$Msg" $aShow  

  if [ $aArgC -lt $aMin -o $aArgC -gt $aMax ]; then
    Msg="Error! Wrong parameters count ($aArgC)"
    echo "$Msg"  > /dev/null 2>&1
    Log $File_Log "$Msg"

    #Help "$Msg"
    exit 0
  fi
}


GetBackupName()
{
  aMode="$1";

  HostName=$(uname -n)
  SysName=$(uname -s)
  SysVer=$(uname -r | awk -F '-' '{ print $1 }')
  Date=$(date "+%y%m%d-%H%M")

  case $aMode in
    Host)    echo ${HostName}_${Date} ;;
    NoDate)  echo ${HostName}_${SysName}_${SysVer} ;;
    *)       echo ${HostName}_${SysName}_${SysVer}_${Date} ;;
 esac
}


MkDir()
{
  aName="$1";

  [ -d $aName ] || mkdir -p $aName
}


IsComment()
# ------------------------
{
 aStr="$1";

 Chr=`echo "$aStr" | awk '{ print substr($0,1,1); }'`
 if [ $Chr = "#" ]; then
    return 1
 fi;
}


MultiCall()
# Execute multi-param call
# IN: Executer, ParamsWithDelim, MoreParam..
# ------------------------
{
  aExecuter="$1"; aParDelim="$2"; aPar1="$3"; aPar2="$4"; aPar3="$5";
  #Log "$0->$FUNCNAME, $aExecuter, $aParDelim, $aPar1, $aPar2, $aPar3"  

  echo "$aParDelim" | awk -F "|" '{for (k=1; k<=NF; k++) print $k}' | \
  while read i; do
    echo
    $aExecuter $i $aPar1 $aPar2 $aPar3
  done
}


case $1 in
    Version)          $1 ;;
esac
  
 