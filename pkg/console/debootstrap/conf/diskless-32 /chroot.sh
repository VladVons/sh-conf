#!/bin/bash
#--- VladVons@gmail.com


StartA()
{
  Log "$FUNCNAME"

  cp $cDir/pattern/fstab /etc
  mkdir -p /mnt/{smb,nfs,hdd}

  cp $cDir/pattern/initramfs.conf /etc/initramfs-tools

  cat $cDir/pattern/exports | \
      sed "s|cDirRoot|${cDirRoot}|g" > /etc/exports

  mkdir -p "$cDir/out"
  cat $cDir/pattern/default | \
    sed "s|cDistr|${cDistr}|g" | \
    sed "s|cArch|${cArch}|g" | \
    sed "s|cConf|${cConf}|g" | \
    sed "s|cNfsServerIP|${cNfsServerIP}|g" | \
    sed "s|cDirRoot|${cDirRoot}|g" > $cDir/out/default

  grep -R "src:" "$cDir/pattern" | sort
}
