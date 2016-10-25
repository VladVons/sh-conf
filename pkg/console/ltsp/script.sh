#!/bin/bash

source ./const.sh
source $DIR_ADMIN/conf/script/system.sh


Init()
{
  Log "$0->$FUNCNAME"
  #http://ternarybit.org/chrome-web-kiosk-guide

  ltsp-build-client --arch i386 --kiosk --skipimage

  ltsp-chroot -ma i386
  #>apt-get install mc ssh firefox remmina rdesktop
  ltsp-update-sshkeys
  ltsp-update-image i386
  ltsp-update-kernels i386

  # ltsp-build-client --arch=i386 --skipimage --chroot=my-i386
  # ltsp-update-image --arch=i386
  # ltsp-update-kernels

  # debootstrap --arch=i386 trusty x-i386
  # apt-cache policy mc
}


case $1 in
    Init)		$1	$2 $3 ;;
    Chroot)		$1 	$2 $3 ;;
esac
