#!/bin/bash

# ------------------------
# Author: Vladimir Vons
# Organization: oster.com.ua
# eMail: VladVons@gmail.com
# Created: 12.03.2016
# ------------------------

Log()
{
  aMsg="$1";

  Msg="$(date +%Y-%m-%d-%a), $(date +%H:%M:%S), $aMsg"
  echo "$Msg"
  echo "$Msg" >> /var/log/chroot.log
}


ExecM()
{
  aExec="$1"; aMsg="$2";

  echo
  Log "$FUNCNAME, $aExec, $aMsg"
  eval "$aExec"
}


ExecPluginFunc()
{
  aFunc="$1"; cDir="$2";

  [ -f $cDir/chroot.sh ] && source $cDir/chroot.sh

  if [ "$(type -t $aFunc)" = "function" ]; then
    $aFunc
    unset -f $aFunc
  fi
}


ExecPlugin()
{
  aFunc="$1";

  ExecPluginFunc $aFunc "./conf"
  ExecPluginFunc $aFunc "./conf/$cConf"
}


FilterFile()
{
  aFile=$1;

  [ -f ./conf/$aFile ] && cat ./conf/$aFile | grep -v "^$\|^#"
  [ -f ./conf/$cConf/$aFile ] && cat ./conf/$cConf/$aFile | grep -v "^$\|^#"
}


PkgCheck()
{
  aPkg="$1";
  dpkg -l "$aPkg" 2>&1 | grep ii | awk '{ print $3 }'
}


PkgInstYes()
{
  aPkg=$1;
  Log "$0->$FUNCNAME, $aPkg"

  ExecM "apt-get install $cAptInstOpt $aPkg"
}


PkgInstCheck()
{
  aPkg=$1;
  #Log "$0->$FUNCNAME, $aPkg"

  if [ -z "$(PkgCheck $aPkg)" ]; then
    PkgInstYes $aPkg
  fi;
}


PkgInst()
{
  Log "$0->$FUNCNAME"

  PkgInstCheck "linux-generic"
  PkgInstCheck "initramfs-tools"
  #PkgInstCheck "grub"

  declare -a Files=$(FilterFile $cFilePkg)
  for i in ${Files[@]}; do
    PkgInstCheck $i
  done;
}


PkgUpdate()
{
  Log "$0->$FUNCNAME"

  dpkg --configure -a
  apt-get update --yes
  apt-get dist-upgrade --yes
}


PkgClean()
{
  Log "$0->$FUNCNAME"

  echo "Clean: $(du -sh /var/cache/apt/archives)"
  echo "Clean: $(du -sh /var/lib/apt/lists)"

  apt-get clean --yes
  apt-get autoremove --yes
  rm -rf /var/lib/apt/lists/*
}


PkgPpaAdd()
{
  Log "$0->$FUNCNAME"

  # need add-apt-repository
  Pkg="software-properties-common"
  if [ -z "$(PkgCheck $Pkg)" ]; then
    apt-get update
    PkgInstYes $Pkg
  fi;

  declare -a Files=$(FilterFile $cFilePpa)
  for i in ${Files[@]}; do
    ExecM "add-apt-repository --yes $i"
  done;

  [ -f ./conf/$cFileSources ] && source ./conf/$cFileSources
  [ -f ./conf/$cConf/$cFileSources ] && source ./conf/$cConf/$cFileSources
}


UserExists()
{
  aUser=$1;

  if  id -u "$aUser" >/dev/null 2>&1; then
    echo "true"
  fi
}


UserAddSudo()
{
  aName="$1";
  Log "$0->$FUNCNAME, $aName"

  if [ -z "$(UserExists $aName)" ]; then 
    adduser $aName
    usermod $aName -a -G sudo
    usermod $aName -a -G audio
  fi
}


SetRootUser()
{
  Log "$0->$FUNCNAME"

  RootPassw=$(grep "root" /etc/shadow | awk -F: '{print $2}')
  if [ "$RootPassw" = "*" ]; then
    ExecM "passwd root" "set root password"
  fi

  #ExecM "dpkg-reconfigure passwd"
}


SetLocale()
{
  aName=$1;
  Log "$0->$FUNCNAME, $aName"

  PkgInstCheck "locales"
  PkgInstCheck "console-cyrillic"

  locale-gen ${aName} ${aName}.UTF-8
  update-locale LC_ALL=${aName}.UTF-8 LANG=${aName}.UTF-8
  dpkg-reconfigure locales
  #dpkg-reconfigure console-cyrillic

  echo && echo "Time zone"
  dpkg-reconfigure tzdata
}


Mount()
{
  aMode=$1;
  Log "$0->$FUNCNAME, $aMode"

  if [ $aMode = 1 ]; then
    mount -t proc   none /proc
    mount -t sysfs  none /sys
    mount -t devpts none /dev/pts
  else
    umount -lf  /proc
    umount -lf  /sys
    umount -lf  /dev/pts
  fi

  #mount
}


Start()
{
  Log "$0->$FUNCNAME"

  ExecPlugin StartA

  ExecM "cat /etc/lsb-release"

  SetLocale "uk_UA"
  SetRootUser
  echo "$cNameDistr" > /etc/hostname

  ExecPlugin StartZ
}


Finish()
{
  Log "$0->$FUNCNAME"

  ExecPlugin FinishA

  update-initramfs -ck all

  PkgClean
  rm -rf /tmp/*

  ExecPlugin FinishZ
}


Defaults()
{
  cArch="i386"
  cDistr="trusty"
  cNfsServerIP="192.168.10.1"
  cNameDistr=${cConf}
  cAptInstOpt="--no-install-recommends --yes"
  cFilePkg="package.lst"
  cFilePpa="ppa.lst"
  cFileSources="sources.list.sh"
}


Pkg()
{
  PkgPpaAdd
  PkgUpdate
  PkgInst
}


All()
{
  Start
  Pkg
  Finish
}


Run()
{
  aDir=$1; aFunc=$2;
  Log "$0->$FUNCNAME, $aDir, $aFunc"

  cd $aDir
  source ./const.sh

  Mount 1
  $aFunc
  Mount 0
}



Defaults

case $1 in
    Run)	$1 $2 $3 $4 ;;
esac
