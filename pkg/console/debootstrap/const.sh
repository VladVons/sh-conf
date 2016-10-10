#!/bin/bash
#--- VladVons@gmail.com

cApp="debootstrap"
cPkgName="$cApp"
cPkgAlso="nfs-kernel-server isc-dhcp-server squashfs-tools genisoimage syslinux pxelinux"

cConf="dless-x-min"
[ -f ./conf/default.conf ] && source ./conf/default.conf
[ -f ./conf/$cConf/default.conf ] && source ./conf/$cConf/default.conf
