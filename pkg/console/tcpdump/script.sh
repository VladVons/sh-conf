#!/bin/bash
#--- VladVons@gmail.com


source $DIR_ADMIN/conf/script/utils.sh


DumpFile()
{
  If="vmbr0"
  Host="host 5.58.82.100"
  #Host="host 46.211.136.5"
  #If="eth0"
  #Host="host 192.168.2.12"

  File="/tmp/dump_${If}_$(date "+%y%m%d-%H%M").txt"
  #ExecM "tcpdump -i eth0 -n -s 0 port not 22 -vvv" "more verbose"
  ExecM "tcpdump -i $If -n -s 0 $Host -vvv -w $File" "Dump to file"
}


Packets()
{
  tcpdump -v icmp
  tcpdump -v arp
  tcpdump -v "icmp or arp"
}


DumpPorts()
{
  # http://www.rationallyparanoid.com/articles/tcpdump.html

  #If="eth0"
  If="vmbr0"
  Host="host 5.58.82.100"

  Ip=`ip -o -4 addr show dev $If | sed 's/.* inet \([^/]*\).*/\1/'`
  File="/tmp/dump_${If}_$(date "+%y%m%d-%H%M").txt"

  echo "If: $If,  Ip: $Ip, Host: $Host, File: $File. Dumping ..."
  tcpdump -i $If -n -s 0 $Host > $File
  grep -oE "${Ip}.[0-9]+" $File | sort| uniq
}



# ------------------------
clear
case $1 in
    DumpPorts)	$1 $2 $3 ;;
    DumpFile)	$1 $2 $3 ;;
esac
