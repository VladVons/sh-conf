#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cEnable="false"
cDescr="Post install"


ScriptAfterInstall()
{
  Log "$FUNCNAME"

  #SysInstall "plymouth-theme-script" "Startap splash"
  
  Theme="Win7"
  
  Dir="/lib/plymouth/themes"
  File=$(ls $Dir/$Theme/*.plymouth)
  
  ExecM "update-alternatives --install $Dir/default.plymouth default.plymouth $File 100"
  ExecM "update-alternatives --config default.plymouth"
  ExecM "update-initramfs -u"
}
