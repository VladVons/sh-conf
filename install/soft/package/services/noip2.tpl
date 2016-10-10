#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="noip2"
cDescr="DyDNS service"
cTag="service,net,dns"
App="/usr/local/bin/$cPkgName"


ScriptInstall()
{
  File="noip-duc-linux.tar.gz"
  DirSrc="/usr/local/src/$cPkgName"
  DirApp="noip-2.1.9-1"

  ExecM "mkdir -p $DirSrc"
  ExecM "cd $DirSrc"

  ExecM "wget http://www.noip.com/client/linux/$File"
  ExecM "tar xf $File"
  ExecM "cd $DirApp"

  ExecM "rm $App"
  ExecM "make install"

  # autostart
  ExecM "cp $DirSrc/$DirApp/debian.noip2.sh $gDirD/noip2"
  ExecM "chmod 755 $gDirD/noip2"

  ExecM "rm -R $DirSrc"

}


ScriptAfterInstall()
{
  ExecM "$gDirD/noip2 start"
  #ExecM "noip2 -C"
}
