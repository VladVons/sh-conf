#!/bin/bash

# ------------------------
# Author: Vladimir Vons
# Organization: oster.com.ua
# eMail: VladVons@gmail.com
# Created: 21.09.2015
# ------------------------


# Global variables
gUser="linux"
gHostProxy="oster.te"
gDirDef="package"
#
gDirConfDef=/admin/conf
gDirBackup=$gDirConfDef/backup
gDirBackupConf=$gDirBackup/conf
#
gVer="Ver 1.02, VladVons@gmail.com"
gFileLog="/var/log/soft.sh.log"
gFileDpkgFast="/tmp/soft.sh.dpkg"
gDirD="/etc/init.d"
gDirPkg="Saved"
gCR=$'\n'
gPpaCnt=0


Log()
# Write message to file and show to screen 
# IN: aMsg
# ------------------------
{
  aMsg="$1";

  Msg="$(GetDate Log), $aMsg"
  echo "$Msg"
  echo "$Msg" >> $gFileLog
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



GetDate()
# get misc date string depends on mode
# ------------------------
{
  aMode="$1";
        
  HostName=$(uname -n)
  SysName=$(uname -s)
  SysVer=$(uname -r | awk -F '-' '{ print $1 }')
  Date=$(date "+%y%m%d-%H%M")

  case $aMode in
    Host) echo "${HostName}_${Date}" ;;
    Log)  echo "$(date +%Y-%m-%d-%a), $(date +%H:%M:%S), $(id -u -n)" ;;
    *)    echo "${HostName}_${SysName}_${SysVer}_${Date}" ;;
 esac
}



ExecM()
# Execute and show message
#-------------------------
{
  aExec="$1"; aMsg="$2";
    
  #echo
  Log "$0-$FUNCNAME, $aExec, $aMsg"
  eval "$aExec"
}


ExecUser()
{
  aExec="$1"; aUser="$2"

  ExecM "su $aUser -c $aExec"
}


Wait()
# ------------------------
{
  aMsg=${1:-"press a key..."}

  read  -p "$aMsg"
  echo
}


Bold()
{
 aStr="$1";
 echo "\e[1m${aStr}\e[21m"
}


_PkgInstall()
# ------------------------
{
  aPackage="$1"; 

  ExecM "apt-get install --yes $aPackage" "Install package"
}


_PkgUpdate()
# ------------------------
{
  ExecM "apt-get update --yes" "update repositories"
}


_PkgCheck()
# ------------------------
{
  aPackage="$1"; 

  ##dpkg -l | awk '{ print $2, $3 }' | sort | grep -w -m 1 "$aPackage"
  ##dpkg -l $aPackage 2>&1 | grep ii | awk '{ print $3 }'
  cat $gFileDpkgFast | grep -w -m 1 "$aPackage"
}


TplList()
# ------------------------
{
  aDir=${1:-"$gDirDef"}

  find $aDir -type f -name "*.tpl" | sort
}


FindScript()
{
  aFile="$1";

  if [ -r "$aFile" ]; then
    echo $aFile
  else
    File=$(find $gDirDef -type f -name "$aFile" | sort | head -n 1)
    if [ "$File" ]; then
      echo $File
    else
      echo "file not found: $aFile" 1>&2
    fi
  fi
}


_DpkgFast()
# ------------------------
{
  # i - install, i - installed
  dpkg -l | grep "^ii" | awk '{ print $2, $3 }' | sort > $gFileDpkgFast
}


DbgInfo()
# ------------------------
{
  echo
  echo -e "$File ($aMode, $cEnable, $(Bold $cPkgName), $cDescr) ..."
}


ModePkgToInstall()
# ------------------------
{
  Installed=$(_PkgCheck $cPkgName)
  if [ -z "$Installed" ]; then
    DbgInfo
  fi
}


ModeBeforeInstall()
# ------------------------
{
  Installed=$(_PkgCheck $cPkgName)
  if [ "$Installed" ]; then
    echo "$FUNCNAME, already installed ${_PkgCheck}"
    return
  fi

  if [ "$cPpa" ]; then
    DbgInfo
    ExecM "add-apt-repository --yes $cPpa"
    gPpaCnt+=1
  fi

  IsFunc=$(type -t ScriptBeforeInstall)
  if [ "$IsFunc" = "function" ]; then
    DbgInfo
    ScriptBeforeInstall
    gPpaCnt+=1
  fi

  # executing just before exit, because it reinit vars by ParseFile
  if [ "$cTplDepends" ]; then
    FilePath=$(FindScript $cTplDepends)
    if [ "$FilePath" ]; then
      ParseFile "$FilePath" $FUNCNAME
    fi;
  fi
}


ModeInstall()
# ------------------------
{
  Installed=$(_PkgCheck $cPkgName)
  if [ "$Installed" ]; then
    echo "$FUNCNAME, already installed ${_PkgCheck}"
    return
  fi

  if [ "$cPkgDepends" ]; then
    DbgInfo
    _PkgInstall "$cPkgDepends"
  fi

  if [ "$cPkgAlso" ]; then
    DbgInfo
    _PkgInstall "$cPkgAlso"
  fi

  if [ "$cPkgDebUrl" ]; then
    DbgInfo

    File=$(basename $cPkgDebUrl)

    ExecM "wget $cPkgDebUrl"
    ExecM "dpkg -i $File"
    ExecM "rm -f $File"
  fi

  if [ "$cPkgName" ]; then
    DbgInfo
    _PkgInstall "$cPkgName"
  fi

  IsFunc=$(type -t ScriptInstall)
  if [ "$IsFunc" = "function" ]; then
    DbgInfo
    ScriptInstall
  fi

  # executing just before exit, because it reinit vars by ParseFile
  if [ "$cTplDepends" ]; then
    FilePath=$(FindScript $cTplDepends)
    if [ "$FilePath" ]; then
      ParseFile "$FilePath" ModeInstall
    fi;
  fi
}


ModeAfterInstall()
# ------------------------
{
  Installed=$(_PkgCheck $cPkgName)
  if [ "$Installed" ]; then
    echo "$FUNCNAME, already installed ${_PkgCheck}"
    return
  fi

  IsFunc=$(type -t ScriptAfterInstall)
  if [ "$IsFunc" = "function" ]; then
    DbgInfo
    ScriptAfterInstall
  fi
}


ModePkgCheckList()
# concate string for whiptail dialog
# ------------------------
{
  Dir=`echo $File | awk -F/ '{print $(NF-1)}'`

  Installed=$(_PkgCheck $cPkgName)
  if [ "$Installed" ]; then
    StrList+=( "$cPkgName" "* $Dir: $cDescr" "ON" )
  else
    StrList+=( "$cPkgName" "  $Dir: $cDescr" "OFF" )
  fi
}


ParseFile()
# ------------------------
{
  aFile="$1";

  aFile=$(FindScript $aFile) 
  if [ -z "$aFile" ]; then
    return 1;
  fi 

  # Unset variables
  cAptList=""
  cDescr=""
  cDir=$(dirname "$aFile")
  cEnable="true"
  cPkgDebUrl=""
  cPkgDepends=""
  cPkgAlso=""
  cPkgName=""
  cPort=""
  cPpa=""
  cTplDepends=""
  cTag=""
  cUser="$gUser"

  # Unset functions
  unset -f ScriptAfterInstall
  unset -f ScriptBeforeInstall
  unset -f ScriptInstall
  unset -f ScriptRemove

  # Include file. Import variables and functions
  source "$aFile"

  return 0
}


ArrFiles()
# ------------------------
{
  declare -a aFiles=("${!1}"); aMode="$2"

  for File in ${Files[@]}; do
    if [ "$File" ]; then
      ParseFile "$File"
      if [ "$cEnable" = "true" ]; then
        $aMode
      else
        echo "package disabled: $File"
      fi
    fi
  done
}


ArrInstall()
# install packages listed in array
# ------------------------
{
  declare -a aFiles=("${!1}");

  gPpaCnt=0
  ArrFiles aFiles[@] ModeBeforeInstall
  if [ $gPpaCnt != 0 ]; then
    _PkgUpdate
  fi

  ArrFiles aFiles[@] ModeInstall
  ArrFiles aFiles[@] ModeAfterInstall
}


DirInstall()
# ------------------------
{
  aDir=${1:-"$gDirDef"};
  Log "$0->$FUNCNAME, $aDir"
  
  # it looses variable value 'StrList' !!!
  # http://mywiki.wooledge.org/BashFAQ/024
  # find $aDir -type f | sort | \
  # looses cycle ! ?
  # done< <(find $aDir -type f | sort)

  # instead use array
  declare -a Files=$(TplList $aDir)
  ArrInstall Files[@]
}


DirToInstall()
# show not installed packages 
# ------------------------
{
  aDir=${1:-"$gDirDef"}
  
  _DpkgFast
  #ParseDir "$aDir" ModePkgToInstall
}


FilesFindTag()
# ------------------------
{
  aTag="$1"
  Log "$0->$FUNCNAME, $aTag"

  declare -a Files=$(TplList)
  
  for File in ${Files[@]}; do
      ParseFile "$File"
      FoundTag=$(echo "$cTag" | egrep -i "$aTag")
      if [ "$FoundTag" ]; then
        echo $File
      fi
  done
}


FileListInstall()
# install packages listed in file
# ------------------------
{
  aFile="$1";
  Log "$0->$FUNCNAME, $aFile"

  if [ -r $aFile ]; then
    declare -a Files=$(cat $aFile | grep "^[^\#]")
    ArrInstall Files[@]
  else
    Log "Error! Can't read file: $aFile"
  fi
}


FileListCheck()
# check packages listed in file
# ------------------------
{
  aFile="$1";
  Log "$0->$FUNCNAME, $aFile"
 
  _DpkgFast

  if [ -r $aFile ]; then
    declare -a Files=$(cat $aFile | grep "^[^\#]")
    for File in ${Files[@]}; do
      FilePath=$(FindScript "$File")
      if [ "$FilePath" ]; then
        ParseFile "$FilePath"    
       
        Installed=$(_PkgCheck $cPkgName)
        if [ "$Installed" ]; then
          echo "+ $FilePath"
        else
          echo "- $FilePath"
        fi
      fi
    done
  else
    Log "Error! Can't read file: $aFile"
  fi
}


FilesInstall()
# install packages space delimited (ex: "arj.tpl zip.tpl some.tpl" )
# ------------------------
{
  aFiles="$1";
  Log "$0->$FUNCNAME, $aFiles"

  _DpkgFast

  declare -a Files
  declare -a FilesCR=$(echo "$aFiles" | tr ' ' '\n')

  for File in ${FilesCR[@]}; do
     FilePath=$(FindScript $File)
     if [ "$FilePath" ]; then
       Files+=( "$FilePath" )
     fi
  done
  
  ArrInstall Files[@]
}
 

FileFuncExec()
# Execute function in file
# ------------------------
{
  aFile="$1"; aFunc="$2";
  Log "$0->$FUNCNAME, $aFile, $aFunc"
  
  FilePath=$(FindScript $aFile)
  if [ "$FilePath" ]; then
    ParseFile $FilePath

    IsFunc=$(type -t $aFunc)
    if [ "$IsFunc" = "function" ]; then
      eval $aFunc
    else 
      Log "Error! Func not found: $FilePath->$aFunc"
    fi
  fi
}
 

Dlg()
# ------------------------
{
  _DpkgFast

  declare -a Files=$(TplList)
  declare -a StrList
  ArrFiles Files[@] ModePkgCheckList

  Result=$(whiptail --title "IDA $gVer" --checklist \
    "Install / remove packages" 35 85 30 \
    "${StrList[@]}" \
    3>&1 1>&2 2>&3)

  ExitCode=$?
  if [ $ExitCode = 0 ]; then
    declare -a ResFiles

    for Item in $Result; do
      ItemUnbrecked=$(echo $Item | sed 's|"||gI')
      Installed=$(_PkgCheck $ItemUnbrecked)
      if [ -z "$Installed" ]; then
        FilePath=$(FindScript $ItemUnbrecked)
        if [ "$FilePath" ]; then
          echo "x: $FilePath" 
          #ResFiles+="${FilePath}${gCR}"
        fi
      fi
    done

    ArrInstall ResFiles[@]
  fi
}


SetProxy()
# APT proxy server: apt-cacher-ng
# ------------------------
{
  aEnable="$1";
  Log "$0->$FUNCNAME, $aEnable"

  File="/etc/apt/apt.conf.d/01-MyProxy"

  if [ $aEnable = "1" ]; then
    echo "Acquire::http::proxy \"http://$gHostProxy:3142\";" > $File
  else
    echo "" > $File
  fi;
}


HomeDump()
# Save user home directory to TAR archive
# ------------------------
{
  Log "$0->$FUNCNAME"

  HomeDir="/home/$gUser"

  ExecM "tar --create --file $HomeDir.tar $HomeDir"
  ExecM "ls -a $HomeDir.tar"
}


HomeRestore()
# Restore user home directory from TAR archive
# ------------------------
{
  Log "$0->$FUNCNAME"

  HomeDir="/home/$gUser"

  ExecM "tar -xf $HomeDir.tar -C /"
  ExecM "chown -R $gUser:$gUser $HomeDir/"
}


PkgSize()
# Get package size
# ------------------------
{ 
  aName="$1"
  apt-cache --no-all-versions show $aName | grep '^Size: '
}


PkgList()
{
  Log "$0->$FUNCNAME"

  dpkg-query -Wf '${Package}\t${Installed-Size}\n' | \
  while read i; do
    Size=$(echo $i | awk '{ print $2 }')
    echo "$i : $Size"
    Total+=$Size
  done
  
  echo "Total: $Total"
}


PkgSave()
{
  Log "$0->$FUNCNAME"

  ExecM "mkdir -p  $gDirPkg"
  ExecM "cd $gDirPkg"
  ExecM "rm $gDirPkg/*"

  ExecM "dpkg-repack $(dpkg --get-selections | grep -v deinstall | cut -f1)"
}


PkgUpdate()
# ------------------------
{
  Log "$FUNCNAME"

  ExecM "dpkg --configure -a" "repair"
  ExecM "apt-get install --fix-broken --yes" "fix broken"

  ExecM "apt-get update --yes" "update repositories"
  ExecM "apt-get dist-upgrade --yes" "upgrade packages and core"
  #ExecM "do-release-upgrade"

  ExecM "apt-get autoremove --yes"
  ExecM "apt-get clean --yes" "remove archive files"
  ExecM "rm /var/lib/apt/lists/*" "remove cache files"
}


ConfUpdate()
# update this config script via rsync
# ------------------------
{
  Log "$0->$FUNCNAME"
  mkdir -p /admin/install && rsync --verbose --recursive --links --times --delete oster.com.ua::Install /admin/install
}


ConfBackup()
{
  Log "$0->$FUNCNAME"
    
  mkdir -p $gDirBackupConf
  #SymLinkBackup
    
  FileName=$gDirBackupConf/$(GetDate )
  
  FileNameArc=${FileName}_lnk.tgz
  tar --create --gzip --file $FileNameArc $(find . -type l)

  FileNameArc=${FileName}_dat.tgz
  tar --create --gzip --dereference --file $FileNameArc .

  echo $FileNameArc

  #FileNameArc=${FileName}.zip
  #zip --recurse-paths --password $gHostFriendPassw $FileNameArc

  #SambaBackup $FileNameArc
}


Help()
# ------------------------
{
  echo "Install applications"
  echo "About: $gVer"
  echo "Syntax: $0 [command]"
  echo "  ConfUpdate"
  echo "  DirInstall [package/[DirName]]"
  echo "  DirToInstall [package/[DirName]]"
  echo "  Dlg"
  echo "  FilesInstall <pkg1.tp pk2.tpl ...>"
  echo "  FileListInstall <FileList.lst>"
  echo "  PkgUpdate"
}


# ------------------------
clear

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

case $1 in
    DirInstall|di)		DirInstall	"$2" $3 ;;
    DirToInstall)		$1		"$2" $3 ;;
    Dlg)			$1		"$2" $3 ;;
    HomeDump)			$1		"$2" $3 ;;
    HomeRestore)		$1		"$2" $3 ;;
    FileFuncExec|ffe)		FileFuncExec	"$2" $3 ;;
    FilesFindTag|fft)		FilesFindTag	"$2" $3 ;;
    FilesInstall|fi)		FilesInstall	"$2" $3 ;;
    FileListCheck|flc)		FileListCheck	"$2" $3 ;;
    FileListInstall|fli)	FileListInstall	"$2" $3 ;;
    SetProxy)			$1		"$2" $3 ;;
    ConfUpdate|cu)		ConfUpdate	"$2" $3 ;;
    ConfBackup|cb)		ConfBackup	"$2" $3 ;;
    PkgSize)			$1		"$2" $3 ;;
    PkgList)			$1		"$2" $3 ;;
    PkgSave)			$1		"$2" $3 ;;
    PkgUpdate|pu)		PkgUpdate	"$2" $3 ;;
    TplList)			$1		"$2" $3 ;;
    *)				Help		"$2" $3 ;;
esac
