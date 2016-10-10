#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="owncloud"
cTplDepends="apache2.tpl,mysql-server.tpl"
cDescr="Cloud file storage"
cTag="internet,cloud"
cAptList="/etc/apt/sources.list.d/$cPkgName.list"

# https://www.howtoforge.com/how-to-install-owncloud-7-on-ubuntu-14.04


ScriptBeforeInstall()
{
  ExecM "wget -q -O - http://download.opensuse.org/repositories/isv:ownCloud:community/xUbuntu_14.04/Release.key | apt-key add -"
  ExecM "echo deb http://download.opensuse.org/repositories/isv:/ownCloud:/community/xUbuntu_14.04 / > $cAptList"
}


ScriptInstall()
{
  SQL="CREATE DATABASE owncloud; GRANT ALL ON app_owncloud.* to 'owncloud'@'localhost' IDENTIFIED BY 'owncloud2015';"
  mysql -u root -p --disable-column-names --batch --execute="$SQL"

  # apache
  a2enmod rewrite 
  a2enmod headers
  a2enmod env
  a2enmod dir
  a2enmod mime
}


OnClientSide()
{
  ExecM "deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/xUbuntu_14.04/ /" > "$cAptList-client"
  apt-get update 
  apt-get install davfs2 owncloud-client -y

  # davfs2 usage
  dpkg-reconfigure davfs2 # (yes)
  usermod -aG davfs2 $gUser
  mkdir -p /mnt/$cPkgName

  # or owncloud GUI
}
