#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua

cPkgName="acestream-full"
cDescr="Free P2P internet TV"
cTag="multimedia,player,p2p,tv"


ScriptInstall()
{
  echo 'deb http://repo.acestream.org/ubuntu/ trusty main' | sudo tee /etc/apt/sources.list.d/acestream.list
  wget -q -O - http://repo.acestream.org/keys/acestream.public.key | sudo apt-key add -
}
