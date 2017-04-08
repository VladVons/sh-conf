#!/bin/bash
#--- VladVons@gmail.com


StartA()
{
  Log "$FUNCNAME"

  UserAddSudo "linux"

  cp $cDir/pattern/fstab /etc

  mkdir -p /mnt/{smb,nfs,hdd}
  mkdir -p $cDir/out/{tftp,etc}

  cp $cDir/pattern/initramfs.conf /etc/initramfs-tools

  # DHCP nameserver problem in ubuntu 16 
  cp $cDir/pattern/rc.local /etc/rc.local

  cat $cDir/pattern/exports | \
      sed "s|cDirRoot|${cDirRoot}|g" > $cDir/out/etc/exports

  cat $cDir/pattern/sources.list | \
      sed "s|cDistr|${cDistr}|g" > /etc/apt/sources.list

  $cDir/pattern/sources.list.sh

  cat $cDir/pattern/default | \
    sed "s|cDistr|${cDistr}|g" | \
    sed "s|cArch|${cArch}|g" | \
    sed "s|cConf|${cConf}|g" | \
    sed "s|cNfsServerIP|${cNfsServerIP}|g" | \
    sed "s|cDirRoot|${cDirRoot}|g" > $cDir/out/tftp/default

  grep -R "src:" "$cDir/pattern" | sort
}

