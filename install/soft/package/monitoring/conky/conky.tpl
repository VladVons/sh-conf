#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="conky"
cPkgDepends="mbmon"
cTplDepends="hddtemp.tpl"
cDescr="System monitor"
cTag="tools"


ScriptInstall()
{
  ExecM "cp $cDir/file/conky.conf /etc/conky/"
  ExecM "cp $cDir/file/conky.desktop ~/.config/autostart/conky.desktop"
}
