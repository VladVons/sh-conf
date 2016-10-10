#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"
  
  User=vladvons
  #su $User -c "vncserver"
  su $User -c "vncpasswd"

  # keyboard
  # http://linuxforum.ru/topic/36372
  # http://c-nergy.be/blog/?p=3858 
  # http://xrdp.sourceforge.net/documents/keymap/rfc1766.html
  # https://github.com/PKRoma/xrdp/blob/master/instfiles/km-0419.ini

  # connect to host with 'rdesktop' to see log messages in terminal
  # setxkbmap -print -verbose 10
  # setxkbmap -layout "us,ru(winkeys)" -model "pc105" -option "grp:ctrl_shift_toggle,grp_led:scroll"
  # http://xrdp.sourceforge.net/documents/keymap/rfc1766.html
  # xrdp-genkeymap /etc/xrdp/km-0422.ini # ua
  # xrdp-genkeymap /etc/xrdp/km-0419.ini # ru
  # xmodmap -pk > mykeys.txt

  # keyboard settings
  # edit /etc/default/keyboard
  # apply changes
  # udevadm trigger --subsystem-match=input --action=change
}


# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		Test	;;
esac
