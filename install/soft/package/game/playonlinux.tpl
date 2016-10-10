#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="playonlinux"
cDescr="Graphical front-end for the Wine games"
cTag="game,virtual"
cAptList="/etc/apt/sources.list.d/$cPkgName.list"


ScriptBeforeInstall()
{
  ExecM "wget -q http://deb.playonlinux.com/public.gpg -O - | sudo apt-key add -"
  ExecM "wget http://deb.playonlinux.com/playonlinux_trusty.list -O - $cApptList"
}
