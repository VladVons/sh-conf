#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="samba"
cPkgDepends="winbind"
cDescr="Windows file sharing server"
cTag="service,file"


ScriptAfterInstall()
{
  ExecM "smbpasswd -a Guest" "Add guest user to samba"
}
