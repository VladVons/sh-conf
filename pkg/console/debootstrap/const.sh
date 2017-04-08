#!/bin/bash
#--- VladVons@gmail.com

cApp="debootstrap"
cPkgName="$cApp"
cPkgAlso="nfs-kernel-server isc-dhcp-server squashfs-tools genisoimage syslinux pxelinux qemu-user-static"

cConf="lxde_a"
[ -f ./conf/default.conf ] && source ./conf/default.conf
[ -f ./conf/$cConf/default.conf ] && source ./conf/$cConf/default.conf
