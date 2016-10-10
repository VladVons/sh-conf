#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="google-chrome-stable"
cPkgDepends="adobe-flashplugin flashplugin-installer"
cDescr="Chrome web browser"
cTag="internet,browser"
cAptList="/etc/apt/sources.list.d/$cPkgName.list"


ScriptBeforeInstall()
{
  ExecM "wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -"
  ExecM "echo deb http://dl.google.com/linux/chrome/deb/ stable main > $cAptList"
}
