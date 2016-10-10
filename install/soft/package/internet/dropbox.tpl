#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="dropbox"
cDescr="Cloud file sharing"
cTag="internet"
cAptList="/etc/apt/sources.list.d/$cPkgName.list"


ScriptBeforeInstall()
{
  ExecM "apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E"
  ExecM "echo deb http://linux.dropbox.com/ubuntu/ vivid main > $cAptList"
}
