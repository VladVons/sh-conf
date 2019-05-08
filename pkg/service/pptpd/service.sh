#!/bin/bash
#--- VladVons@gmail.com

#https://www.digitalocean.com/community/tutorials/vpn-pptp-ru

# error "Protocol not available"
#http://poptop.sourceforge.net/dox/gre-protocol-unavailable.phtml

#IP ranges
#https://bgp.he.net/dns/mail.ru

source ./const.sh
shttps://bgp.he.net/dns/mail.ruource $DIR_ADMIN/conf/script/service.sh


ExecEx()
{
  #echo > /var/log/syslog
  Exec
}


TestEx()
{
  Test

  #ifconfig
}


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  sysctl -p
  modprobe ppp_mppe
}


# ------------------------
clear
case $1 in
    Exec|e)     ExecEx	$2 ;;
    Install)    $1      $2 ;;
    Init)       $1      $2 ;;
    *)		TestEx	;;
esac
