#!/bin/bash

#Copyright:   (c) 2017, Vladimir Vons, UA
#Author:      Vladimir Vons <VladVons@gmail.com>
#Created:     2018.05.23
#Descr:        Extract files from RaspberryPi image to TFTP and NFS

FileImg="img/2018-04-18-raspbian-stretch.img"
DirNFS="/mnt/hdd/data1/share/public/image/nfs/raspi-2"
DirTFTP="/mnt/hdd/data1/share/public/image/tftp/raspi-2"


ImgToDir()
{
    DirMnt='/mnt/img'
    mkdir -p $DirMnt 
    mkdir -p $DirTFTP 
    mkdir -p $DirNFS{/boot,/mnt/smb/temp}

    # MOUNTING A HARD DISK IMAGE INCLUDING PARTITIONS USING LINUX
    #losetup -f --show -P $FileImg
    echo "Image information $FileImg"
    fdisk -l -b 512 $FileImg

    echo "Extract boot partition to $DirTFTP ..."
    Offset=$(fdisk -l -b 512  $FileImg | grep -i fat32 | awk '{print $2*512}')
    mount -o ro,loop,offset=$Offset $FileImg $DirMnt
    cp -Rp $DirMnt/* $DirNFS/boot
    cp -Rp $DirMnt/* $DirTFTP
    chmod -R -x+X $DirNFS/boot $DirTFTP 
    umount $DirMnt

    echo "Extract root partition to $DirNFS ..."
    Offset=$(fdisk -l -b 512  $FileImg | grep -i linux | awk '{print $2*512}')
    mount -o ro,loop,offset=$Offset $FileImg $DirMnt
    cp -Rp $DirMnt/* $DirNFS
    umount $DirMnt
}


AdjustRoot()
{
    echo "Adjust file system ..."
    #mkdir -p $DirNFS/{dev,proc,sys,mnt/smb/temp,tmp}

    rm -R $DirNFS/dev/*
    rm $DirNFS/etc/init.d/resize2fs_once
    cp $0 $DirNFS/home/pi

    echo "proc /proc proc defaults 0 0" > $DirNFS/etc/fstab
    echo "#//192.168.2.100/temp /mnt/smb/temp cifs username=guest,password=guest,noauto,iocharset=utf8,sec=ntlm,uid=1000,rw,vers=1.0  0  0" >> $DirNFS/etc/fstab

    # skeletion for all users
    mkdir $DirNFS/etc/skel/Desktop
    ln -s /mnt/smb/temp $DirNFS/etc/skel/Desktop/temp

    #/usr/share/rpd-wallpaper

    # for 
    mkdir -p  $DirNFS/var/log/all
    chmod 777 $DirNFS/var/log/all
}


Env()
{
    echo "Locales ..."

    #Loc="en_US"
    Loc="uk_UA"

    locale-gen ${Loc} ${Loc}.UTF-8
    update-locale LC_ALL=${Loc}.UTF-8 LANG=${Loc}.UTF-8
    dpkg-reconfigure locales

    dpkg-reconfigure tzdata

    echo "Enable SSH"
    update-rc.d ssh defaults
    update-rc.d ssh enable
    invoke-rc.d ssh start
}


PkgA()
{
    apt-get update
    apt-get upgrade --yes

    apt-get install --yes mc doublecmd-gtk remmina rdesktop audacious conky
    apt-get install --yes ntfs-3g wget libreoffice-l10n-uk 
    apt-get install --yes epoptes-client

    # hardware media omxplayer
    wget -qO - http://bintray.com/user/downloadSubjectPublicKey?username=bintray | sudo apt-key add -
    echo "deb http://dl.bintray.com/kusti8/chromium-rpi jessie main" > /etc/apt/sources.list.d/rpi-youtube.list
    apt-get update
    apt-get install --yes chromium-browser rpi-youtube

    apt-get autoremove --yes
    apt-get clean
}


ExtractImage()
{
    ImgToDir
    AdjustRoot
}


HostInstall()
{
    Env
    PkgA
    echo "Done"
}


Help()
{
    echo "$0 <e|i>"
    echo "e - Extract image to TFTP and NFS folders"
    echo "i - Install under deployed host"
    echo 
    echo "Info"
    echo "TFTP dir to extract: $DirTFTP"
    echo "NFS  dir to extract: $DirNFS"
    echo "Image in internet  : https://downloads.raspberrypi.org/raspbian_latest"
}


clear
case $1 in
    ExtractImage|e)     ExtractImage ;;
    HostInstall|i)      HostInstall  ;;
    *)                  Help;;
esac
