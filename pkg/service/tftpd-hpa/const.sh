#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh
source /etc/default/tftpd-hpa

#http://wiki.linuxquestions.org/wiki/Diskless_Workstation

cApp="tftpd-hpa"

cPkgName="$cApp"
cPkgAlso="isc-dhcp-server inetutils-inetd syslinux pxelinux initramfs-tools nfs-kernel-server tftp"

#7z x image.wim
#cPpa="ppa:nilarimogard/webupd8"
#cPkgAlso="p7zip dos2unix wimtools"

cProcess="tftpd"
cService="$gDirD/$cApp"
cPort="69"
cLog1="$gFileSysLog"

cDirTftp="/srv/tftp"
cDirSysLinux="/usr/lib/syslinux"
cDirPxeLinux="/usr/lib/PXELINUX"

cDirIso="_inf/iso"
cDirMnt="/mnt/iso"
