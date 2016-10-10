#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="opera"
cPkgDepends="adobe-flashplugin flashplugin-installer"
cDescr="Opera web browser"
cTag="internet,browser"
cAptList="/etc/apt/sources.list.d/$PkgName.list"


ScriptBeforeInstall()
{
  ExecM "wget -O - http://deb.opera.com/archive.key | apt-key add -"
  ExecM "echo deb http://deb.opera.com/opera/ stable non-free > $cAptList"
}
