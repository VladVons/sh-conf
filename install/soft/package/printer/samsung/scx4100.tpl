#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua
# http://werhinin.livejournal.com/6466.html


cPkgName="samsungmfp-scanner"
cPkgDepends="samsungmfp-scanner-usblp-fix sane xsane cups"
cDescr="Samsung printer/scaner driver"
cTag="system,print,scaner"
cAptList="/etc/apt/sources.list.d/$cPkgName.list"


ScriptBeforeInstall()
{
  ExecM "wget -O - http://www.bchemnet.com/suldr/suldr.gpg | sudo apt-key add -"
  ExecM "echo deb http://www.bchemnet.com/suldr/ debian extra > $cAptList"

  # reboot
}
