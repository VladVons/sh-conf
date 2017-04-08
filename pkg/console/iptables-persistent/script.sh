#!/bin/bash
#--- VladVons@gmail.com


source $DIR_ADMIN/conf/script/system.sh
source ./rules.sh


Save()
# ------------------------
{
  Log "$0->$FUNCNAME"

  eval "$cService save"
}


Load()
# ------------------------
{
  Log "$0->$FUNCNAME"

  eval "$cService load"
}


RulesClear()
{
  Log "$0->$FUNCNAME"

  iptables --flush
  iptables --table nat --flush
  iptables --table nat --delete-chain

  iptables -P INPUT   ACCEPT
  iptables -P FORWARD ACCEPT
  iptables -P OUTPUT  ACCEPT

  ExecM "iptables -L INPUT -vn | grep DROP"
}


RulesTest()
# NOTE: if everething is OK and you want to prevent 'shutdown': 
# Cancel it with "shutdown -c" 
#------------------------
{
  Log "$0->$FUNCNAME"

  WaitTime=2

  clear
  RulesClear
  sleep 1
  RulesExecute

  iptables -L -nv

  echo "Computer will be rebooted in $WaitTime minutes ..."
  shutdown -r +${WaitTime} "Ctrl-C to abort. Than you can save settings with './service.sh RulesSave'"
}


RulesSave()
# ------------------------
{
  Log "$0->$FUNCNAME"

  File="/etc/iptables/rules.v4"

  iptables-save > /etc/iptables/rules.v4
  echo "saved to $File" 
}


RulesCommit()
# ------------------------
{
  Log "$0->$FUNCNAME"

  RulesClear
  RulesExecute
}


RulesCommitReboot()
# ------------------------
{
  Log "$0->$FUNCNAME"

  RulesCommit

  reboot
}


Test()
{
  echo "Hello"
}


# ------------------------
case $1 in
    Save)		$1	$2 ;;
    Load)		$1	$2 ;;
    RulesClear)		$1	$2 ;;
    RulesTest)		$1	$2 ;;
    RulesSave)		$1	$2 ;;
    RulesCommit)	$1	$2 ;;
    RulesCommitReboot)	$1	$2 ;;
    Test)		$1	$2 ;;
esac
