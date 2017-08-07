#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua

cPkgName="virtualbox-5.0"
cDescr="Virtual box"
cTag="virtual,system"
cAptList="/etc/apt/sources.list.d/$cPkgName.list"
# http://download.virtualbox.org/virtualbox/5.0.4/Oracle_VM_VirtualBox_Extension_Pack-5.0.4-102546.vbox-extpack


ScriptBeforeInstall()
{
  #ExecM "wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O - | apt-key add -"
  ExecM "wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -"

  ExecM "echo deb http://download.virtualbox.org/virtualbox/debian trusty contrib > $cAptList"

  # allow user catch USB devices in guest system
  usermod -G vboxusers -a $gUser
}

Expand()
{
 VBoxManage modifyhd YOUR_HARD_DISK.vdi --resize SIZE_IN_MB
}
