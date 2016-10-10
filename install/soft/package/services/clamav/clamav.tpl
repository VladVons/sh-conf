#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="clamav"
cPkgDepends="clamav-daemon"
cDescr="Antivirus"
cTag="system,antivirus"


ScriptInstall()
{
  ExecM "freshclam" "update virus database"
}
