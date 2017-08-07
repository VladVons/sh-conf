#!/bin/bash

ppa_wine()
{
  #wget https://dl.winehq.org/wine-builds/Release.key
  #apt-key add Release.key
  #apt-add-repository 'https://dl.winehq.org/wine-builds/ubuntu/'

  apt-add-repository 'https://dl.winehq.org/wine-builds/ubuntu/'
  wget https://dl.winehq.org/wine-builds/Release.key
  apt-key add Release.key

  dpkg --add-architecture i386
}

ppa_playonlinux()
{
  # playonlinux
  wget -q "http://deb.playonlinux.com/public.gpg" -O - | sudo apt-key add -
  wget http://deb.playonlinux.com/playonlinux_precise.list -O /etc/apt/sources.list.d/playonlinux.list
}

Install()
{
  ppa_wine
  ppa_playonlinux

  apt-get update
  apt-get install playonlinux
  apt-get install winehq-stable

  wine --version
}

Install

