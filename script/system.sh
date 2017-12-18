#!/bin/bash
# System.sh 
#--- VladVons@gmail.com

source $DIR_ADMIN/conf/script/common.sh


gUsersFile="/etc/passwd"


HostPing()
# ------------------------
{
 aHost=$1;
      
 ping -c 3 $aHost > /dev/null
 if [ $? -eq 0 ]; then
    echo "ok"
 fi
}


CheckFileRead()
# Checks if file exists for reding
# IN: FileName
# ------------------------
{
  #CheckParam "CheckFile(File='$1')" $# 1 1
  aFile=$1

  if [ ! -r $aFile ]; then
    Help "Error! Can't read file: $aFile" 21
  fi
}


ShowFile()
# IN: FileName, Action
# Actions: S, SG, SGC, ST, SGT
# S   -Show whole file
# SG  -Show+Grep
# SGC -Show+Grep+Count
# ST  -Show+ Tail
# SGT -Show+Greo+Tail   
# ------------------------
{
  CheckParam "$0->$FUNCNAME(aFile=$1, aAction=$2, $3, $4)" $# 2 4
  aFile=$1; aAction=$2;

  CheckFileRead $aFile

  FileSize=$(du $aFile | awk '{ print $1 }')
  echo "size: $FileSize"

  case $aAction in
    All|SA)   		cat $aFile ;;
    Grep|SG)		cat $aFile | grep -i "$3" --color=auto ;;
    GrepCount|SGC)	cat $aFile | grep -c -v "grep" ;;
    Tail|ST)		cat $aFile | tail "-$3" ;;
    GrepTail|SGT)	cat $aFile | grep -i "$3" | tail "-$4" | grep -i "$3" --color=auto ;;
    Uncomment|SU)	cat $aFile | grep -v "^$\|^#" ;;

    *)   echo "Unknown option $aAction"
 esac
}


ProcInMem()
# Test if process in memory
# IN:  aProcName
# OUT: ProcOwner<->ProcID<->ProcCommand
# ------------------------
{
  CheckParam "$0->$FUNCNAME(aName='$1')" $# 1 1
  aName=$1

  ps aux | egrep -iv "(grep|ProcInMem)" | grep -i $aName | awk '{ print $1, $2, $11, $12 }' | grep -i $aName --color=auto
}


ProcKill()
{
  CheckParam "$0->$FUNCNAME(aName='$1')" $# 1 1
  aName=$1;

  ProcInMem $aName

  List=`ps aux | egrep -iv '(grep|ProcInMem)' | grep -i $aName | awk '{ print $2}'`
  kill $List
  sleep 1
  
  ProcInMem $aName
}


SockProg()
{
  CheckParam "$0->$FUNCNAME(Prog='$1')" $# 1 1
  [ $? -eq 0 ] || exit
  aProg=$1

  lsof -ai tcp -c $aProg | grep --color=auto $aProg
}


SockPort()
{
# Show socket status
# IN: aPort
# ------------------------
  CheckParam "$0->$FUNCNAME(Port='$1')" $# 1 1
  [ $? -eq 0 ] || exit
  aPort=$1

  lsof -i :$aPort | grep -i 'listen' --color=auto
}


NetStat()
{
# Show socket status
# IN: aServices
# ------------------------
  CheckParam "$0->$FUNCNAME(aService='$1')" $# 1 1
  [ $? -eq 0 ] || exit
  aService=$1

  netstat -tulpn | egrep "$aService" --color=auto
}


ServiceAutostart()
{
  CheckParam "$0->$FUNCNAME(aService='$1', aEnable='$2')" $# 2 2
  aService=$1; aEnable=$2;
 
  if [ $aEnable == 1 ]; then
    update-rc.d $aService defaults
  else
    update-rc.d -f $aService remove
  fi;
}


UserExists()
{
  aUser=$1;
  CheckParam "$0->$FUNCNAME(aUser='$aUser')" $# 1 1 0

  if  id -u "$aUser" >/dev/null 2>&1; then
    echo "true"
  fi
}


UserList()
# List all users
# IN: None
# OUT: UserName<->UserID<->UserGroup
# ------------------------
{
  CheckParam "$0->$FUNCNAME()" $# 0 0

  CheckFileRead $gUsersFile
  cat $gUsersFile | awk -v LIMIT=1000 -F: '($3 >= LIMIT) && ($ 3!= 65534) {print  $1, $3, $6, $7 }' | sort	
}


UserAddSys()
# Add user to system
# IN: User, Passw, Group, Shell, HomeDir
# ------------------------
{
  aUser=$1; aPassw=$2; aGroup=$3; aShell=$4; aHomeDir=$5;

  useradd $aUser --groups $aGroup --home $aHomeDir --shell $aShell
  #echo "$aUser:$aPassw" | chpasswd
  echo -e "$aPassw\n$aPassw\n" | passwd $aUser
 
  #usermod $aUser -a -G sudo
  #usermod $aUser -s /usr/sbin/nologin
}


UserAdd()
# Add user to system
# IN: Login, Password [, -NS]
# ------------------------
{
  CheckParam "$0->$FUNCNAME(User='$1', Passw='$2', Mode='$3')" $# 2 3
  aUser=$1; aPass=$2; aMode=$3;

  Cnt=$(ListUsers | grep "$aUser" | grep -c -v grep)
  if [ $Cnt = "0" ]; then
    HomeDir="/home/$aUser"
    Group=$aUser
    case $aMode in
      NoShell|NS)
        useradd $aUser
        echo $aPass | passwd $aUser --stdin
        ;;
      Hosting|-H)
        Group="www-data"
        HomeDir="/home/hosting/active"
        if [ ! -d $HomeDir ]; then
          mkdir -p $HomeDir
          chown $Group:$Group $HomeDir
        fi

        HomeDir="$HomeDir/$aUser"

        AddUserSys $aUser $aPass $Group /usr/sbin/nologin $HomeDir
        #useradd $aUser --groups $Group --home $HomeDir --shell /usr/sbin/nologin
        #echo $aPass | passwd $aUser --stdin

        HomeDir="$HomeDir/public_html"
        mkdir -p $HomeDir

        if [ ! -r $HomeDir/index.php ]; then
          echo "Hello user '$aUser' !" >> $HomeDir/index.html
        fi
        ;;
     *)
        echo $aPass | pw useradd $aUser -h 0
        ;;
    esac

    mkdir -p $HomeDir
    chown -R $aUser:$Group $HomeDir
    chmod -R 775 $HomeDir
 else
    echo "User exist $aUser"....
 fi
}


PkgInstallTry()
{
  CheckParam "$0->$FUNCNAME(aPackage='$1')" $# 1 1
  aPackage="$1";

  Flag=$(dpkg-query -W -f='${Status}' $aPackage 2>/dev/null | grep -c "ok installed")
  if [ $Flag == 0 ]; then
    PkgInstall $aPackage
  fi;
}


PkgInstall()
{
  CheckParam "$0->$FUNCNAME(aPackage='$1')" $# 1 1
  aPackage="$1";

  echo
  apt-get install --yes $aPackage

  # adjust 'dpkg -i' dependencies
  #apt-get install -f
}


PkgDownload()
{
  CheckParam "$0->$FUNCNAME(aPackage='$1')" $# 1 1
  aPackage="$1";

  apt-get download $aPackage
}


PkgClean()
{
  Log "$0->$FUNCNAME"

  apt-get autoremove
  apt-get autoclean
  apt-get clean
}


PkgRemove()
{
  CheckParam "$0->$FUNCNAME(aPackage='$1')" $# 1 1
  aPackage="$1";

  apt-get remove --purge --yes $aPackage
  PkgClean
}



PkgVersion()
{
  CheckParam "$0->$FUNCNAME(aPackage='$1')" $# 1 1
  aPackage="$1";

  Ver=$(dpkg -s "$aPackage" | grep -i "version:")
  echo $aPackage $Ver | grep $aPackage --color=auto
}


PkgGetSize()
{   
  CheckParam "$0->$FUNCNAME(aPackage='$1')" $# 1 1
  aName="$1"
  Log "$0->$FUNCNAME, $aName"

  apt-cache --no-all-versions show $aName | grep '^Size: '
}


PkgList()
{
  Log "$0->$FUNCNAME"

  dpkg -l
}


UsbList()
{
  ls /dev/disk/by-id/usb* | \
  while read dev; do
    readlink -f $dev
  done;
}


ManPrint()
{
  CheckParam "$0->$FUNCNAME(aFile="$1", aDir='$2')" $# 1 2
  aFile="$1"; aDir=${2:-$gDirMan};
  Log "$0->$FUNCNAME, $aFile, $aDir"
  
  MkDir $aDir  

  File=$aDir/$aFile.txt
  echo "saved to $File"
  man $aFile > $File
}


case $1 in
    ServiceAutostart)	$1 $2 $3 $4 $5 ;;
    UserAdd)		$1 $2 $3 $4 $5 ;;
    UserList)		$1 $2 $3 $4 $5 ;;
    UsbList)		$1 $2 $3 $4 $5 ;;
    PkgInstall)		$1 $2 $3 $4 $5 ;;
    PkgInstallTry)	$1 $2 $3 $4 $5 ;;
    PkgClean)		$1 $2 $3 $4 $5 ;;
    ProcKill)		$1 $2 $3 $4 $5 ;;
    ProcInMem)		$1 $2 $3 $4 $5 ;;
    ServiceAutostart)	$1 $2 $3 $4 $5 ;;
    ManPrint)		$1 "$2" $3 $4 $5 ;;
esac
