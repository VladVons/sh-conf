#!/bin/bash
#--- VladVons@gmail.com

AddDeb()
{
  aPkg="$1"; aStr="$2";
  echo $aStr >> /etc/apt/sources.list.d/$aPkg.list
}


AddDeb "google-chrome-stable" "deb http://dl.google.com/linux/chrome/deb/ stable main"
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

AddDeb "dropbox" "deb http://linux.dropbox.com/ubuntu/ vivid main"
apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
