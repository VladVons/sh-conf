#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="hddtemp"
cDescr="HDD temperature monitor"
cTag="tools,hdd"


ScriptAfterInstall()
{
  ExecM "dpkg-reconfigure hddtemp" "check allow run from not root user"
}