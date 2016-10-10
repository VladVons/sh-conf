#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName=""
cPkgDepends="libstdc++5:i386 lib32ncurses5 openbsd-inetd"
cDescr="Firebird database"
cTag="db"


ScriptInstall()
{
  File="Firebird-15.tar.gz"
  Dir="FirebirdCS-1.5.6.5026-0.i686" 

  wget http://sourceforge.net/projects/firebird/files/firebird-linux-i386/1.5.6-Release/FirebirdCS-1.5.6.5026-0.i686.tar.gz/download -O $File
  tar xzvf $File
  cd $Dir
  ./install.sh
  apt-get install -f
  cd ..
  rm -R $Dir 
  rm $File

  #telnet localhost 3050
  #/opt/firebird/bin/isql -user SYSDBA -pass masterkey $DB
  #> show tables;
}
