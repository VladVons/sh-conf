#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="acroread"
cPkgDepends="gdebi libgtk2.0"
cDescr="Adobe acrobat reader"
cTag="office,pdf"
cAptList="/etc/apt/sources.list.d/$cPkgName.list"

ScriptBeforeInstall()
{
  ExecM "echo deb http://archive.canonical.com precise partner > $cAptList"
}
