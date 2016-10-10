#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgDepends="gettext sp-auth"
cDescr="Free P2P internet TV"
cTag="multimedia,player,p2p,tv"
cPpa="ppa:venerix/pkg"


ScriptInstall()
{
  app="sopcast-player"
  app_gz="$app-0.8.5.tar.gz"
  
  ExecM "wget http://sopcast-player.googlecode.com/files/$app_gz"
  ExecM "tar -zxvf $app_gz"
  ExecM "cd $app"
  ExecM "make"
  ExecM "make install"
  ExecM "cd .."
  ExecM "rm -R $app $app_gz"
}
