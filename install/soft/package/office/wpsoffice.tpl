#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName=""
cPkgDepends="ttf-mscorefonts-installer"
cDescr="Kingsoft Office"
cTag="office"

#http://wps-community.org/download.html


ScriptInstall()
{
  File="wps-office_9.1.0.4975~a19p1_amd64.deb"
  #http://wps-community.org/download.html
  ExecM "wget http://kdl.cc.ksosoft.com/wps-community/download/a19/$File"
  ExecM "dpkg -i $File"
  ExecM "apt-get install -f"

  _PkgInstall "qt4-dev-tools"
  ExecM "git clone https://github.com/wps-community/wps_i18n.git" "get multilanguage"
  ExecM "cd wps_i18n"
  ExecM "make install" 

  File="uk_UA.zip"
  ExecM "wget http://wps-community.org/download/dicts/$File" "Check spell"
  ExecM "unzip $File -d /opt/kingsoft/wps-office/office6/dicts"

  ExecM "rm -r /usr/share/fonts/wps-office" "delete china fonts"
  ExecM "fc-cache -fv" "refresh fonts"
}
