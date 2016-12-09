#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/system.sh


CheckAudio()
{
  # LXC ?
  #https://bmullan.wordpress.com/2013/11/20/how-to-enable-sound-in-lxc-linux-containers/

  aplay -l
  ls -l /dev/snd
  lsmod | grep '^snd' | column -t
  lspci | egrep -i "multimedia|audio|sound|ac97|emu"
  lsusb | egrep -i "multimedia|audio|sound|ac97|emu"
  cat /proc/asound/cards

  amixer scontrols
  amixer set 'Master' 80%

  # F6 key to change sound card
  alsamixer 

  #find /lib/modules/$(uname -r) | grep snd

  # noice
  cat /dev/urandom | aplay -D hw:1,0 -f S16_LE -c 2 -r 44100
  speaker-test -c 2 -r 48000 -D hw:0,3
}


# ------------------------
Init()
{
  mpc update
  mpc random on
  mpc repeat on
  mpc play
}


AddMusic()
# ------------------------
{
  source ./sevice.sh

  Exec stop
  killall musicpd
  sleep 5

  mpd --create-db /usr/local/etc/mpd.conf
  sleep 5
  Exec start
}


# ------------------------
case $1 in
    CheckAudio)	$1	$2 ;;
esac
