#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
{
  ExecM "java -version"
}


InstallEx()
{
  add-apt-repository --yes ppa:webupd8team/java
  add-apt-repository --yes ppa:openjdk-r/ppa
  apt-get update
  apt-get install oracle-java8-set-default oracle-java8-installer
  apt-get install openjdk-8-jdk

  # on 64b platform
  apt-get install libc6 libncurses5 libstdc++6 lib32z1 libbz2-1.0

  update-alternatives --get-selections
  java -version

  Url="https://dl.google.com/dl/android/studio/ide-zips/2.2.3.0/android-studio-ide-145.3537739-linux.zip"
  File=${Url##*/}

  wget $Url
  unzip $File -d /opt

  cp file/51-android.rules /etc/udev/rules.d
  adduser linux plugdev
}


# ------------------------
#clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Init)	$1	$2 ;;
    Install)	InstallEx	$1	$2 ;;
    *)		TestEx	;;
esac
