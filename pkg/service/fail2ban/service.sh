#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source ./script.sh
source $DIR_ADMIN/conf/script/service.sh


# Todo:
# "fail2ban ban time exponential increasing"
# http://habrahabr.ru/post/238303/
# KyvStar 46.211.181.19


TestEx()
{
  Test

  #ExecM "iptables -L fail2ban-freeswitch-tcp"
  #ExecM "iptables -L fail2ban-ssh"
  #ExecM "iptables -L fail2ban-pure-ftpd"

  #ExecM "tcpdump -i $gExtIf dst portrange 5060-5080 -v"

  ExecM "RulesTest"

  ExecM "iptables -S | grep fail2ban"
  ExecM "iptables -L INPUT -vn | grep DROP"

  ExecM "fail2ban-client status ssh"
  ExecM "fail2ban-client status fail2ban"
  ExecM "fail2ban-client status freeswitch"

  ExecM "GetBanCountry"

  # fail2ban-client get loglevel
  # fail2ban-client set loglevel 1-4
}


# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		TestEx	;;
esac
