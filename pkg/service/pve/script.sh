#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh

#man lxc.container.conf


CheckCPU()
{
  Log "$0->$FUNCNAME, $aID"

  egrep --color "vmx" /proc/cpuinfo
  lscpu | grep -i --color "virt"
}


ctStart()
{
  aID=$1;
  Log "$0->$FUNCNAME, $aID"

  cLog1="$LogDir/${aID}l.log"
  cLog2="$LogDir/${aID}c.log"
  ExecM "lxc-start --logpriority=DEBUG --logfile=$cLog1 --console-log=$cLog2 --foreground --name=${aID}"

  echo "log files: $cLog1, $cLog2"
}


qmCommands()
{
  aID=$1;
  Log "$0->$FUNCNAME, $aID"

  #--- VM commands
  #qm list
  #qm shutdown $aID
  #qm stop $aID
  qm unlock $aID
  #qm config $aID
}


vmCreate()
{
  Log "$0->$FUNCNAME, $aID"

  qm create 300 \
    -memory 512 \
    -ide0 4 \
    -net0 e1000 \
    -cdrom /var/lib/vz/template/iso/WinXP.iso \
    -storage local \
    -ostype wxp \
    -name MyName \
    -description MyDescr
}


CT_Templates()
{
  #--- lxc images https://www.turnkeylinux.org

  pveam update
  pveam available

  # only OS
  pveam available --section system

  # show downloaded on storage
  pveam list data2

}

# ------------------------
case $1 in
    CheckCPU)		$1	$2 ;;
    ctCommands)		$1	$2 ;;
    ctStart)		$1	$2 ;;
    vmCreate)		$1	$2 ;;
esac
