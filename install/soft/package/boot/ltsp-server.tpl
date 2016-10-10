#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua

cPkgName="ltsp-server"
cTplDepends="tftpd-hpa.tpl"
cDescr="Linux terminal server project"
cTag="rdp"


ScriptAfterInstall()
{
  #http://ternarybit.org/chrome-web-kiosk-guide

  ltsp-build-client --arch i386 --kiosk --skipimage
  ltsp-chroot -ma i386
  #>apt-get install mc ssh firefox remmina rdesktop
  ltsp-update-sshkeys
  ltsp-update-image i386
  ltsp-update-kernels i386
}