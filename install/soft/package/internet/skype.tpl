#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="skype"
cDescr="Skype messanger"
cTag="internet,chat"
cAptList="/etc/apt/sources.list.d/$cPkgName.list"


ScriptBeforeInstall()
{
  ExecM "echo deb http://archive.canonical.com/ubuntu trusty partner > $cAptList"
}
