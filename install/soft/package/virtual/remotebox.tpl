#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="remotebox"
cDescr="Remote VirtualBox client"
cTag="virtual"
cPort="18083"
cAptList="/etc/apt/sources.list.d/$cPkgName.list"


ScriptBeforeInstall()
{
  #http://xmodulo.com/how-to-manage-virtualbox-vms-on-remote-headless-server.html

  ExecM "wget -q -O - http://archive.getdeb.net/getdeb-archive.key | sudo apt-key add -"
  ExecM "echo deb http://archive.getdeb.net/ubuntu trusty-getdeb apps > $cAptList"
}
