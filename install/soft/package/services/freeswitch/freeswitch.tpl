#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="freeswitch"
#cPkgDepends="$cPkgName-meta-vanilla $cPkgName-lang-ru $cPkgName-sounds-ru-ru-elena-16000"
#cTplDepends="lua.tpl"
cDescr="Voip server"
cTag="service,voip"
cPort="5060,5080"
#cAptList="/etc/apt/sources.list.d/$cPkgName.list"

cPkgDepends1="lame mpg123 checkinstall libmpg123-dev libmp3lame-dev libshout3-dev libsndfile-dev libvpx2-dev libyuv-dev libopus-dev libvpx-dev flite libsoundtouch-dev"
cPkgDepends2="autoconf automake devscripts gawk g++ git-core libjpeg-dev libncurses5-dev libtool make python-dev gawk pkg-config libtiff5-dev libperl-dev libgdbm-dev libdb-dev gettext libssl-dev libcurl4-openssl-dev libpcre3-dev libspeex-dev libspeexdsp-dev libsqlite3-dev libedit-dev libldns-dev libpq-dev"


Install()
{
  SrcDir="/usr/src/$cPkgName"

  cd /usr/src
  git clone -b v1.4 https://freeswitch.org/stash/scm/fs/freeswitch.git
  cd $SrcDir

  # generate modules.conf
  ./bootstrap.sh
  # we have our own, override it
  cp $cDir/file/src/modules.conf $SrcDir/modules.conf

  ./configure
  make

  # compile additional mods
  # cd /usr/src/freeswitch/src/mod/applications/mod_spy
  # make && make install

  checkinstall

  # 8 kHz Standard Audio
  make sounds-install
  make moh-install
  # 16 kHz High Definition Audio
  make hd-moh-install
  make hd-sounds-install
  # 32 kHz Ultra High Definition Audio
  make uhd-moh-install
  make uhd-sounds-install
  # 48 kHz CD Quality Audio
  make cd-sounds-install
  make cd-moh-install

  # russian sounds
  make sounds-ru-install
  make cd-sounds-ru-install
  make uhd-sounds-ru-install
  make hd-sounds-ru-install

  # add user
  useradd freeswitch
  passwd -l freeswitch

  # set permission
  cd /usr/local/
  chown -R freeswitch:freeswitch freeswitch
  chmod -R g+w freeswitch

  # autoload
  cp $cDir/file/etc/init.d/freeswitch /etc/init.d/freeswitch
  cp $cDir/file/etc/default/freeswitch /etc/default/freeswitch
  update-rc.d freeswitch defaults
  service freeswitch start

  ln -s /usr/local/freeswitch/bin/fs_cli /usr/local/bin/fs_cli
  fs_cli -x "sofia status"
}


ScriptBeforeInstall()
{
  Install

  # for Debian only
  #ExecM "echo deb http://files.freeswitch.org/repo/deb/freeswitch-1.6/ jessie main > $cAptList"
  #ExecM "wget -O - http://files.freeswitch.org/repo/deb/freeswitch-1.6/key.gpg | apt-key add -"
}
