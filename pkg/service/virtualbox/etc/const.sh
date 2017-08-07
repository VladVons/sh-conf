#!/bin/bash

#http://wiki.linuxquestions.org/wiki/Diskless_Workstation

source $DIR_ADMIN/conf/script/const.sh

cApp="virtualbox"

cPkgName="$cApp"
cPkgAlso="isc-dhcp-server inetutils-inetd syslinux pxelinux initramfs-tools nfs-kernel-server tftp"

cProcess="tftpd"
cService="$gDirD/$cApp"
cPort="69"
cLog1="$gFileSysLog"

cDirSysLinux="/usr/lib/syslinux"
cDirPxeLinux="/usr/lib/PXELINUX"

cDirIso="_inf/iso"
cDirMnt="/mnt/iso"
cDirTftp="/mnt/hdd/data1/share/public/image/tftp"

