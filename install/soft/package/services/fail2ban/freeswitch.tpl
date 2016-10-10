#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="fail2ban"
cPkgDepends="python"
cDescr="ban hosts that cause multiple authentication errors"
cTag="service,ddos"


Install()
{
  exit
  SrcDir="/usr/src/$cPkgName"

  cd /usr/src
  git clone https://github.com/fail2ban/fail2ban.git
  cd $SrcDir
}
