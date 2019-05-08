#!/bin/bash
# Utils.sh
#--- VladVons@gmail.com

source $DIR_ADMIN/conf/script/system.sh


SysInfo()
{
  Log "$0->$FUNCNAME"

  ExecM "uname -r"			"Kernel version"
  ExecM "lsb_release -a"		"Distr version"
  ExecM "X -version"			"Xorg version"
  ExecM "lscpu"				"CPU info"
  ExecM "grep 'MemTotal' /proc/meminfo" "Mem total"
  ExecM "df -h"				"Disk ussage"
  ExecM "lspci"				"Hardware short list"
  ExecM "lspci | egrep -i 'vga|3d|2d'"	"Video card vendor"
  #ExecM "dmesg | egrep -i 'vga|3d|2d'"	"Video driver installed"
  ExecM "ifconfig -a | grep -i eth"     "Network cards"
}


UsersBackup()
{
  Log "$0->$FUNCNAME"

  # get FIRST_GID from file 
  . /etc/adduser.conf

  Dir1="${gDirBackupConf}/users"
  mkdir -p $Dir1

  awk -v LIMIT=$FIRST_GID -F: '($3>=LIMIT) && ($3!=65534)' /etc/passwd > $Dir1/passwd.txt
  awk -v LIMIT=$FIRST_GID -F: '($3>=LIMIT) && ($3!=65534)' /etc/group  > $Dir/group.txt
  awk -v LIMIT=$FIRST_GID -F: '($3>=LIMIT) && ($3!=65534) {print $1}' /etc/passwd | tee - | egrep -f - /etc/shadow > $Dir1/shadow.txt
  cp /etc/gshadow $Dir1/gshadow.txt
}


PasswGenerator() 
{
  MATRIX='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
  LENGTH=10
  while [ ${n:=1} -le $LENGTH ]; do
    PASS="$PASS${MATRIX:$(($RANDOM%${#MATRIX})):1}"
    let n+=1
  done
  
  echo "$PASS"
}


SymLinkCheck()
{
  Log "$0->$FUNCNAME"

  find . -type l | \
  while read i; do
    FullPath=$(readlink $i)
    if [ ! -r $FullPath ]; then
      echo "not exists: $i -> $FullPath"
    fi
  done
}


SymLinkBackup()
{
  Log "$0->$FUNCNAME"

  MkDir $gDirBackupConf
  FileName=$gDirHost/SymLinks.txt
  echo > $FileName

  find . -type l | grep -v $gExclArch | \
  while read i; do
    FullPath=$(readlink $i)
    if [ -r "$FullPath" ]; then
      if [ -d "$FullPath" ]; then
        echo "d $i $FullPath" >> $FileName
      else
        echo "f $i $FullPath" >> $FileName
      fi
    fi
  done
}


SymLinkRestore()
{
  Log "$0->$FUNCNAME"

  FileName=$gDirHost/SymLinks.txt

  cat $FileName | \
  while read i; do
    ArrLine=($i)	#bash array
    if [ ! -r ${ArrLine[2]} ]; then
      echo "create  ${ArrLine[1]} -> ${ArrLine[2]}"
      if [ ${ArrLine[0]} == "d" ]; then
        mkdir -p ${ArrLine[2]}
      else
        touch ${ArrLine[2]}
      fi;
    fi;
  done
}


SymLinkGo()
{
  CheckParam "$0->$FUNCNAME(aFile='$1')" $# 1 1
  aFile=$1;
  Log "$0->$FUNCNAME, $aFile"
  
  if [ -L $aFile ]; then
    Dir=$(dirname $(readlink $aFile))
    if [ -d $Dir ]; then
      cd $Dir
      pwd 
    fi;
  fi;
}


SambaBackup()
{
  aFile=$1;
  Log "$0->$FUNCNAME, $aFile"

  MountDir="/mnt/smb/samba"
  MkDir $MountDir

  if [ ! -z $gHostFriend ]; then
    if [ ! -z $(HostPing $gHostFriend) ]; then
      echo OK
      umount -fl $MountDir
      ExecM "mount -t cifs //$gHostFriend/$gHostFriendShare $MountDir -o user=$gHostFriendUser -o password=$gHostFriendPassw"
      if [ $? -eq 0 ]; then
        MkDir $MountDir/conf
        ExecM "cp $aFile $MountDir/conf"
        umount -fl $MountDir
      else 
        echo "Cant connect to //$gHostFriend/$gHostFriendShare"
      fi;
    else
      echo "Cant ping $gHostFriend"	
    fi;   
  else
    echo "Variable 'gHostFriend' not defined in $gFileHost"
  fi; 
}


ConfBackup()
{
  Log "$0->$FUNCNAME"

  MkDir $gDirBackupConf
  SymLinkBackup

  FileName=$gDirBackupConf/$(GetBackupName)

  FileNameArc=${FileName}_lnk.tgz
  Files=$(find $gDirConf $gDirHost -type l | sort)
  tar --verbose --create --gzip --file $FileNameArc $Files

  FileNameArc=${FileName}_dat.tgz
  tar --verbose --create --gzip --dereference --exclude=_inf --exclude=.git --file $FileNameArc $gDirConf

  #FileNameArc=${FileName}.zip
  #zip --recurse-paths --symlinks --password $gHostFriendPassw $FileNameArc $gDirConf

  #FileNameArc=${FileName}_dat_sh.tgz
  #echo $FileNameArc
  #tar cfvz $FileNameArc $(find $gDirConf -type f -name "*.sh")

  #SambaBackup $FileNameArc
}


DirArchive()
{
  aDirSrc="$1"; aDirDst="$2";
  CheckParam "$0->$FUNCNAME(aDirSrc='$aDirSrc', [aDirDst='$aDirDst'])" $# 2 2
  Log "$0->$FUNCNAME, $aDirSrc, $aDirDst"

  FileName=$aDirDst/$(GetBackupName NoDate)_$(echo $aDirSrc | sed "s|/|_|g").tgz
  ExecM "tar --create --gzip --file $FileName $aDirSrc"
}



ConfUpdate()
{
  if [ "$gSkipRsync" == "yes" ] ; then
    echo "Warning: gSkipRsync = $gSkipRsync"
  else
    cd $DIR_ADMIN/conf/pkg/service/rsync
    ./script.sh conf
  fi
}


ArchUnpack()
# ------------------------
{
  aFile="$1"; aDstDir="$2";
  Log "$0->$FUNCNAME, $aFile, $aDstDir"

  if [ -f $aFile ] ; then
    if [ "$aDstDir" ]; then
        cd $aDstDir
    fi

    case $aFile in
        *.tar.bz2) tar xvjf     $aFile ;;
        *.tar.gz)  tar xvzf     $aFile ;;
        *.bz2)     bunzip2      $aFile ;;
        *.rar)     unrar x      $aFile ;;
        *.gz)      gunzip       $aFile ;;
        *.tar)     tar xvf      $aFile ;;
        *.tbz2)    tar xvjf     $aFile ;;
        *.tbz)     tar xvjf     $aFile ;;
        *.tgz)     tar xvzf     $aFile ;;
        *.zip)     unzip        $aFile ;;
        *.7z)      7z x         $aFile ;;
        *)         echo "Unknown archive extension '${aFile}'" ;;
    esac
  else
    echo "File not found '${aFile}'"
  fi;
}


DirFindLatest()
{
  CheckParam "$0->$FUNCNAME(aDir='$1')" $# 1 1
  aDir="$1";
  Log "$0->$FUNCNAME, $aDir"

  find $aDir -printf '%T+ %p\n' | \
    sort -r | \
    head --lines 40
}


DirStrFind()
{
  CheckParam "$0->$FUNCNAME(aDir='$1',aFind='$2')" $# 2 2
  aDir="$1"; aFind="$2";
  Log "$0->$FUNCNAME, $aDir, $aFind"

  grep --dereference-recursive --ignore-case "$aFind" "$aDir" | sort | grep --color=auto "$aFind"
}


DirStrReplace()
{
  aDir="$1"; aFind="$2"; aReplace="$3";
  CheckParam "$0->$FUNCNAME(aDir='$aDir', aFind='$aFind', aReplace='$aReplace')" $# 3 3
  Log "$0->$FUNCNAME, $aDir, $aFind, $aReplace"

  if YesNo "replace string '$aFind' with '$aReplace' in directory $aDir"; then
    grep --dereference-recursive --files-with-matches --null --ignore-case "$aFind" "$aDir" | \
      xargs --null \
      sed -i.bak "s|${aFind}|${aReplace}|gI"
      #sed -i.bak "s:${aFind}:${aReplace}:gI"

    echo "remove bakups: find . -type f -name '*.bak' -delete"
  fi;
}


DirSetOwnerPerm()
# ------------------------
{
  CheckParam "$0->$FUNCNAME(aDir='$1',aOwner='$2')" $# 2 2
  aDir="$1"; aOwner="$2";
  Log "$0->$FUNCNAME, $aDir, $aOwner"

  find "$aDir" -print0 | xargs -0 chown "$aOwner"
  find "$aDir" -type f -print0 | xargs -0 chmod 664
  find "$aDir" -type f -name "*.sh" -print0 | xargs -0 chmod 774	# warn
  find "$aDir" -type d -print0 | xargs -0 chmod 775

  #chgrp -R $aOwner $aDir
}


DirSetAllPerm()
# ------------------------
{
  aDir="$1";
  Log "$0->$FUNCNAME, $aDir"

  #chmod -R go+rX,go-w $aDir

  find "$aDir" -type f -print0 | xargs -0 chmod 666
  find "$aDir" -type d -print0 | xargs -0 chmod 777
}


DirRemoveOld()
# ------------------------
{
  CheckParam "$0->$FUNCNAME(aDir='$1',aDays='$2')" $# 2 2
  aDir=$1; aDays=$2;
  Log "$0->$FUNCNAME, $aDir, $aDays"


  #find $aDir -type f -atime +${aDays} -delete
  ## touch -m -a -d "40 days ago" FileName.txt
  ## stat FileName.txt 

  #find -L $aDir -type f -atime +${aDays} -delete
  #find -L $aDir -type d -ctime +${aDays} -delete -empty

  find $aDir -type f -mtime +${aDays} -delete
  find $aDir -type d -mtime +${aDays} -delete -empty
}


DirRemoveMask()
# ------------------------
{
  CheckParam "$0->$FUNCNAME(aDir='$1',aMask='$2')" $# 2 2
  aDir=$1; aMask=$2;
  Log "$0->$FUNCNAME, $aDir, $aMask"

  find $aDir -type f -name "$aMask" -delete
}


DirClearMask()
# ------------------------
{
  CheckParam "$0->$FUNCNAME(aDir='$1',aMask='$2')" $# 2 2
  aDir=$1; aMask=$2;
  Log "$0->$FUNCNAME, $aDir, $aMask"

  find $aDir -type d -name "$aMask" | \
  while read i; do
    echo "Clear folder: $i"
    rm -R $i/*
  done
}


DirToLower()
# ------------------------
{
  CheckParam "$0->$FUNCNAME(aDir='$1')" $# 1 1
  aDir=$1;
  Log "$0->$FUNCNAME, $aDir"

  find $aDir | xargs rename 'y/A-Z/a-z/' *
  #rename 'y/A-Z/a-z/' *
 
  #rename 's/\.jpeg$/\.jpg/' *.jpeg
}


DirSync()
# ------------------------
{
  CheckParam "$0->$FUNCNAME(aDirSrc='$1',aDirDst='$2')" $# 2 2
  aDirSrc=$1; aDirDst=$2;
  Log "$0->$FUNCNAME, $aDirSrc, $aDirDst"
  
  #touch $aDirSrc/MyFile{1..10000}
  rsync --recursive --verbose --update --links $aDirSrc/* $aDirDst
}


DirSize()
# ------------------------
{
  CheckParam "$0->$FUNCNAME(aDir='$1')" $# 1 1
  aDir=$1;
  Log "$0->$FUNCNAME, $aDir"
  
  du -hs $aDir  
}


FindFuncLib()
# Search for object in libraries
#------------------------
{
  CheckParam "$0->$FUNCNAME(aFunc='$1')" $# 1 1
  aFunc=$1;
  Log "$0->$FUNCNAME, $aFunc"

  Dir="/usr/lib/";

  find $Dir -type f -executable | \
  while read I; do
    OBJ_DUMP="$(objdump -tT $I 2>/dev/null | grep "$aFunc")";
    if [ -n "${OBJ_DUMP}" ]; then
      echo "$I"
      echo "$OBJ_DUMP"
    fi;
  done
}


PkgListInst()
# install packages listed in file located in pkg/list directory
# ./utils.sh PkgListInst proxmox.lst
{
  aFile="$1";
  Log "$0->$FUNCNAME, $aFile"

  declare -a PkgInst=$(dpkg -l | grep "^ii" | awk '{ print $2 }' | sort | xargs)
  declare -a PkgList=$(grep -v "#" $gDirPkgList/$aFile)

  for Pkg in ${PkgList[@]}; do
    if [[ " ${PkgInst[@]} " =~ " ${Pkg} " ]]; then
      echo "skip $Pkg"
    else
      echo
      echo "install --== $Pkg ==---"
      apt-get install $Pkg --yes --no-install-recommends
    fi
  done
}


PkgInstalled()
{
  Log "$0->$FUNCNAME"

  declare -a PkgInst=$(dpkg -l | grep "^ii" | awk '{ print $2 }' | sort | xargs)

  echo "$gDirPkg"
  find $gDirPkg -type f -name const.sh | sort | \
  while read File; do
    cPkgName=""
    cProcess="---"
    source $File

    if [ "$cPkgName" ]; then
      if [[ " ${PkgInst[@]} " =~ " ${cPkgName} " ]]; then
        printf "%-20s %-15s %s\n" $cPkgName $cProcess $File
      fi
    fi
  done
}


PkgRemoveAll()
{
  Log "$0->$FUNCNAME"

  if YesNo "remove all packages"; then
    dpkg -l | awk '{print $2}' | xargs dpkg --remove
  fi;
}


PkgRemoveOldKernel()
{
  Log "$0->$FUNCNAME"


  if YesNo "Hint: Update and reboot system first. Continue purge ?"; then
    echo "Packages to remove"

    # proxmox
    List=$(dpkg --list | grep -P -o "pve-kernel-\d\S+-pve" | grep -v $(uname -r | grep -P -o ".+\d"))
    printf '%b\n' $List
    apt-get purge $List

    # ubuntu
    List=$(dpkg --list | grep -P -o "linux-image-\d\S+-generic" | grep -v $(uname -r | grep -P -o ".+\d"))
    printf '%b\n' $List
    apt-get purge $List

    apt-get autoremove
  fi;
}


PkgRemoveBad()
{
  Log "$0->$FUNCNAME"

  apt-get install byobu
  purge-old-kernels
  apt-get autoremove --purge

  declare -a Files=$(dpkg -l | tail -n +6 | awk '{print $1,$2}' | grep -v "ii" | awk '{print $2}')

  for i in ${Files[@]}; do
    Log "$0->$FUNCNAME, $i"

    apt-get remove --purge --yes $i

    rm /var/lib/dpkg/info/${i}.*
    dpkg --purge --force-remove-reinstreq $i

    if [[ $i != *"linux-image"* ]]; then
      apt-get install --yes $i
    fi

    apt-get autoremove --yes
  done

  PkgUpdate
}


PkgRemoveForce()
{
  aPkg=$1
  Log "$0->$FUNCNAME, $aPkg"

  mv /var/lib/dpkg/info/$aPkg.* /tmp/
  dpkg --remove --force-remove-reinstreq $aPkg
  apt remove --purge $aPkg
}


PkgSave()
{
  Log "$0->$FUNCNAME"
 
  echo "save packages to $gDirBackupPkg"
  MkDir $gDirBackupPkg
  cd $gDirBackupPkg
  rm $gDirBackupPkg/*

  dpkg-repack $(dpkg --get-selections | grep -v deinstall | cut -f1)
}


PkgUpdate()
# ------------------------
{
  Log "$FUNCNAME"

  ExecM "rm /var/lib/dpkg/lock"

  ExecM "apt-get autoremove --yes"
 
  ExecM "dpkg --configure -a" "repair"
  #ExecM "dpkg --configure -a --force-depends"
  ExecM "apt-get install --fix-broken --yes" "fix broken"

  ExecM "apt-get update --yes" "update repositories"
  ExecM "apt-get dist-upgrade --yes" "upgrade packages and core"

  #ExecM "apt-get install update-manager-core"
  #ExecM "do-release-upgrade - d"

  ExecM "apt-get autoremove --yes"
  ExecM "apt-get clean --yes" "remove archive files"
  #ExecM "rm /var/lib/apt/lists/*" "remove cache files"
}




MailSendFile()
{
  aAddrTo=$1; aSubj=$2; aBody=$3; aFile=$4;
  Log "$0->$FUNCNAME, $aAddrTo, $aSubj, $aBody, $aFile"  
  
  echo "$aBody" && uuencode $aFile | mail -s "$aSubj" $aAddrTo
}


NetGetExtIP()
{
  #Log "$0->$FUNCNAME"

  wget -qO - ipinfo.io/ip
  #wget -qO- icanhazip.com
  #wget -qO - ipecho.net/plain
  #wget -qO - ip.appspot.com
  #wget -qO - v4.ipv6-test.com/api/myip.php

  #curl -s "http://v4.ipv6-test.com/api/myip.php"
}


NetGetHosts()
{
  Log "$0->$FUNCNAME"

  ExecM "arp -a | sort | grep ether"
  ExecM "nmap -sP $gIntNet"
}


NetGetHostOS()
{
  aHost=$1
  Log "$0->$FUNCNAME, Host->$aHost"

  ExecM "nmap -v -Pn -O $aHost"
}

NetGetHostPorts()
{
  CheckParam "$0->$FUNCNAME(aHost='$1')" $# 1 1
  aHost=$1;
  Log "$0->$FUNCNAME, $aHost"

  #http://www.cyberciti.biz/networking/nmap-command-examples-tutorials/
  nmap -F -Pn $aHost
  nmap -v -d -Pn -p 80 $aHost
  nmap -v -d -Pn -p 0-65535 $aHos
  nmap -v -d -Pn -p 0-65535 --min-parallelism 1000 94.247.62.24
}


NetCheckPort()
{
  CheckParam "$0->$FUNCNAME(aHost='$1', aPort='$2')" $# 2 2
  aHost=$1; aPort=$2;
  Log "$0->$FUNCNAME, $aHost, $aPort"

  #nmap -PN -sN $aHost -p $aPort
  #nc -z host.example.com 1-1024
  nc -zv oster.com.ua $aHost $aPort
}

NetSpeed1()
{
  File="speedtest_cli.py"

  if [ ! -r $File ]; then
    #apt install speedtest-cli
    wget --no-check-certificate https://raw.github.com/sivel/speedtest-cli/master/$File
    chmod +x $File
  fi

  ./$File
}


NetSpeed2()
{

  #http://o3.ua/support/speed_test/
  Url="ftp://176.37.214.174/pub/video/doc/Ot_Chernobilya_Do_Focusimy_SATRip.avi"

  apt-get install axel
  axel -o /tmp/speedtest.dat $Url
}


LogClear()
{
  Log "$0->$FUNCNAME"

  find /var/log -type f -name "*.gz" -delete
  find /var/log -type f -name "*.[1-9]" -delete
  find /var/log -type f -name "*.tmp" -delete
  find /var/log -type f -name "*.txt" -delete

  find /var/log -type f | \
  while read i; do
    echo "" > $i
  done
}


Test()
{
  Log "$0->$FUNCNAME"
}


ShutDown()
# ShutDown 30 "today 21:30"   (ShutDown in 30 minutes and wakeup in 21:30)
# ShutDown 0  "tomorrow 8:30" (ShutDown now and wakeup in 21:30)
{
  CheckParam "$0->$FUNCNAME(aWait='$1', aWakeUp='$2')" $# 0 3
  aWait=${1:-0}; aWakeUp="$2";
  Log "$0->$FUNCNAME, $aWait, $aWakeUp"
  
  echo 0 > /sys/class/rtc/rtc0/wakealarm
  if [ ! -z "$aWakeUp" ]; then
    Seconds=$(date +%s --date "$aWakeUp")
    echo "wake up $aWakeUp ($Seconds)"
    rtcwake --verbose --mode no --utc --time $Seconds
  fi; 

  # debug info
  ExecM "cat /proc/driver/rtc"
  ExecM "cat /sys/class/rtc/rtc0/wakealarm"

  Msg="Power off in $aWait minutes. To abort 'killall shutdown'"
  echo $Msg 
  shutdown -P +${aWait} $Msg &
  #--pm-suspend
}


FatCheckDisk()
{
  dosfsck -t -a /dev/sdb1
}


UsbFormat()
{
  Log "$0->$FUNCNAME"

  # ubuntu zero fill free space
  #dd if=/dev/zero of=outputfile bs=1024K count=1024

  for dev in $(UsbList); do
    Size=$(blockdev --getsz $dev)
    if YesNo "format $dev $(expr $Size / 1000))Kb"; then
      umount -f $dev
      dd if=/dev/zero of=$dev bs=512 count=1
    
      mkntfs --fast --force $dev
      #mkdosfs   -n 'Label' -F32 -I $dev
      #mkfs.ext3 -n 'Label' -I $dev
    fi;
  done;
}


CpuStress()
{
  Log "$0->$FUNCNAME, $aWait, $aWakeUp"

  Loops=4

  for i in `seq 1 $Loops`; do 
    echo "Thread $i" 
    cat /dev/zero > /dev/null &
  done
  # killall cat

  #stress --cpu 4
}


DiskClean()
{
  LogClear

  apt-get clean
  rm /var/lib/apt/lists/*

  cd $gDirPkg/service/apache2
  ./script.sh DelTemp

  df -h
}


GrubRepair()
{
  ExecM "fdisk -l | egrep '/sd[a-z]' | egrep -iv 'swap|fat|ntfs'"

  DevBoot="sdx2"
  Dev=${DevBoot:0:3}
  mount -t ext4 /dev/$Dev /mnt/$Dev
  grub-install --recheck --root-directory=/mnt/$Dev /dev/$Dev
}


Hibernate()
{
  # disable
  systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

  # enable
  #systemctl umask sleep.target suspend.target hibernate.target hybrid-sleep.target

  systemctl list-unit-files
}


MultipleInstance()
{
  Count=$(ps -eaf | grep $cApp.sh | egrep -v "grep|defunct" | wc -l)
  if [ $Count -gt 1 ]; then
    exit 1
  else
    exit 0
  fi
}



clear
case $1 in
    ArchUnpack)        $1 $2 $3 $4;;

    ConfBackup|cb)     ConfBackup ;;
    ConfUpdate|cu)     ConfUpdate ;;

    CpuStress)         $1 $2 $3 $4;;
    GrubRepair)        $1 $2 $3 $4;;
    FindFuncLib)       $1 $2 $3 $4;;

    DirClearMask)      $1 $2 $3 $4;; 
    DirSize)           $1 $2 $3 $4;; 
    DirArchive)        $1 $2 $3 $4;; 
    DirFindLatest)     $1 $2 $3 $4;; 
    DirRemoveOld)      $1 $2 $3 $4;; 
    DirRemoveMask)     $1 $2 $3 $4;; 
    DirSetOwnerPerm)   $1 $2 $3 $4;;
    DirSetAllPerm)     $1 $2 $3 $4;;
    DirStrReplace)     $1 $2 $3 $4 $5;;
    DirStrFind)        $1 $2 $3 $4;;
    DirSync)           $1 $2 $3 $4;; 
    DirToLower)        $1 $2 $3 $4;;

    DiskClean)         $1 $2 $3 $4;;
    LogClear)          $1 $2 $3 $4;;
    MailSendFile)      $1 $2 $3 $4;;

    NetCheckPort)      $1 $2 $3 $4;;
    NetGetExtIP)       $1 $2 $3 $4;;
    NetGetHosts)       $1 $2 $3 $4;;
    NetGetHostOS)      $1 $2 $3 $4;;
    NetGetHostPorts)   $1 $2 $3 $4;;
    NetSpeed1)         $1 $2 $3 $4;;
    NetSpeed2)         $1 $2 $3 $4;;

    PasswGenerator)    $1 $2 $3 $4;;

    PkgInstalled)      $1 $2 $3 $4;;
    PkgListInst)       $1 $2 $3 $4;;
    PkgRemoveAll)      $1 $2 $3 $4;;
    PkgRemoveBad)      $1 $2 $3 $4;;
    PkgRemoveForce)    $1 $2 $3 $4;;
    PkgRemoveOldKernel) $1 $2 $3 $4;;
    PkgSave)           $1 $2 $3 $4;;
    PkgUpdate|pu)      PkgUpdate $2 $3 $4;;

    SambaBackup)       $1 $2 $3 $4;;
    ShutDown)          $1 $2 "$3" $4;;
    SymLinkBackup)     $1 $2 $3 $4;;
    SymLinkGo)         $1 $2 $3 $4;;
    SymLinkRestore)    $1 $2 $3 $4;;
    SysInfo)           $1 $2 $3 $4;;
    Test)              $1 $2 $3 $4;;
    UsbFormat)         $1 $2 $3 $4;;

    UsersBackup)       $1 $2 $3 $4;;
    UsersRestore)      $1 $2 $3 $4;;
esac
