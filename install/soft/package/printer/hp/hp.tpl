#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="hplip"
cPkgDepends="hplip-gui cups"
cDescr="HP printer drivers and util"
cTag="system,print"


ScriptAfterInstall()
{
  ExecM "hp-setup" "GUI installation tool"
}
