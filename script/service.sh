#!/bin/bash
# Service.sh
#--- VladVons@gmail.com

source $DIR_ADMIN/conf/script/system.sh


ShowLog()
{
  aFile="$1";

  if [ -n "$aFile" ]; then
    echo
    if [ "$aFile" == "$gFileSysLog" ]; then
      ShowFile "$aFile" SGT "$cProcess" 15
    else
      #echo "$Log1, $gFileSysLog, $cProcess"
      ShowFile "$aFile" ST 15
    fi;
  fi;
}


Test()
# ------------------------
{
  Log "$0->$FUNCNAME"

  Info=$(uname --operating-system  --nodename)
  echo "Machine: $Info"
  echo "Software ver: $gVerInfo"

  if [ -n "$cApp" ] && [ -n "$cPkgName" ]; then
    echo
    PkgVersion "$cPkgName"
  fi;

  if [ -n "$cProcess" ]; then
    #echo
    MultiCall ProcInMem "$cProcess"
  fi;

  #if [ -n "$cService" ]; then 
    #echo
    #"$cService" status
  #fi;

  if [ -n "$cPort" ]; then
    MultiCall SockPort "$cPort"
    ExecM "netstat -lnp | grep --color=auto $cProcess"
  fi;

  ShowLog $cLog1
  ShowLog $cLog2
}


Exec()
# ------------------------
{
  aAction=${1:-"restart"}
  Log "$0->$FUNCNAME, $cApp, $aAction"

  eval "$cService $aAction"

  sleep 3
  $cService status

  echo
  Test
}


Install()
# ------------------------
{
  Log "$0->$FUNCNAME"

  if [ "$cPkgDepends" ]; then
    PkgInstall "$cPkgDepends"
  fi

  if [ "$cPkgName" ]; then
    PkgInstall "$cPkgName"
  fi

  if [ "$cPkgAlso" ]; then
    PkgInstall "$cPkgAlso"
  fi
}
