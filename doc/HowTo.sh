#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua

#mkdir -p /admin/conf && rsync --verbose --recursive --links --times --delete tr24.oster.com.ua::AdminFull /admin/conf

# undelete file
#extundelete --restore-file /admin/conf/pkg/console/debootstrap/conf/package.lst /dev/mapper/vm--ubu64--vg-root

Package: software-properties-common (apt-add-repository)


. $DIR_ADMIN/conf/Common.sh



#auto eth1
    #iface eth1 inet static
    #address 192.168.0.10
    #netmask 255.255.255.0
    #gateway 192.168.0.1
    #dns-nameservers 192.168.0.1 8.8.8.8

# commands
#http://www.linuxguide.it/command_line/linux_commands_ru.html
# scelet
#http://linuxmint.blogspot.com/2010/11/22-linux.html

Boot()
{
 #http://theurbanpenguin.com/wp/index.php/ubuntu-14-04-custom-boot-screen/
 #http://sysads.co.uk/2014/08/install-super-boot-manager-ubuntu-14-04/
}

SysInfo()
{
  Log "$0->$FUNCNAME"

  ExecM "lsb_release -a" "get ubuntu version"

  cat /proc/cpuinfo
  lscpu
  lshw -class processor
  dmidecode
  hardinfo
  dmesg | grep tty
}


Device()
# ------------------------
{
  Log "$0->$FUNCNAME"
   

  # get video card
  update-pciids
  lspci | egrep -i 'vga|3d|2d'
  lshw -class display
  dmesg | egrep -i 'vga|3d|2d'
  xrandr

  #ExecM "lspci"				"Info"
  #ExecM "lspci -v"				"Info ex"
  #ExecM "lshw -C network | grep -i name"	"Net cards"
  #ExecM "dmesg | grep -i eth"			"Net cards"
  #ExecM "ifconfig -a | grep -i eth"		"Net cards"

  #ExecM "lspci -vnn | grep -i VGA -A 12"	"Vide cards"


  # get list of new attached devices
  # dump current list
  ls /dev/ > /tmp/dev_list_1.txt
  # attach new device and dump
  ls /dev/ > /tmp/dev_list_2.txt
  # now compare
  diff --suppress-common-lines -y  /tmp/dev_list_1.txt /tmp/dev_list_2.txt
}


Disk()
{
  Log "$0->$FUNCNAME"

  #cfdisk
  #mkfs -t ext4 /dev/sdX
  
  # check BAD blocks and mark them 
  badblocks -v -s /dev/sda > BadBlocks.txt
  fsck -l BadBlocks.txt /dev/sda  

  lshw -C disk
  blkid
  fdisk -l
  parted -l
  ssm list
 
  mount -o loop path/to/iso/file/YOUR_ISO_FILE.ISO /media/iso

  mount -t cifs //192.168.2.1/temp /mnt/smb/tr24 -o user=guest -o password=guest
  //192.168.2.2/Temp /mnt/smb/tr24  cifs username=Guest,password=Guest,iocharset=utf8,sec=ntlm,uid=1000,rw  0  0

  mount -r -t ufs -o ufstype=ufs2 /dev/sdb4 /mnt/ufs
  convmvfs /mnt/ufsx -o allow_other -o srcdir=/mnt/ufs -o icharset=koi8-u -o ocharset=utf-8

  mount -t ext4 /dev/sdb5 /mnt/hdd/data3

  mount -t ntfs /dev/sdb1 /mnt/ntfs
  /dev/sda5      /mnt/ntfs       ntfs            defaults,uid=1000,rw  0  0
  #/dev/sdc1 on /mnt/usb type fuseblk (rw,nosuid,nodev,allow_other,blksize=4096)

  mount -t vboxsf -o uid=XXX share-name /path/to/folder/share/

  rsync -avzu /media/usb/src /mnt/data2/dst
}


Audio()
{
  apt-get install alsa-utils
  alsamixer
  amixer scontrols
  amixer sset 'Master' 50%

  # list audio devices
  aplay -l
  ls -l /dev/snd
  lsmod | grep '^snd' | column -t
  lspci | egrep -i "multimedia|audio|sound|ac97|emu"
  cat /proc/asound/card*/id

  find /lib/modules/$(uname -r) | grep snd

  # Test HDMI sound
  speaker-test --channels 2 --device hw:0,0

  addgroup <username> audio
}


Video()
{
  add-apt-repository ppa:mc3man/trusty-media --yes
  apt-get install ffmpeg

  ffmpeg -f v4l2 -list_formats all -i /dev/video0
  ffmpeg -f v4l2 -s 320x240 -r 25 -i /dev/video0 -f alsa -ac 1 -i hw:0 http://localhost:8090/feed1.ffm
  ffmpeg -f v4l2 -s 320x240       -i /dev/video0                       http://localhost:8090/feed1.ffm

  http://www.nick-horne.com/tag/raspberry-pi-camera-module-streaming/
  https://www.raspberrypi.org/forums/viewtopic.php?t=45368
  apt-get install crtmpserver

  vlc rtsp://192.168.2.121:554
  v4l2-ctl --list-devices

  #
  echo 500 > /sys/class/backlight/intel_backlight/brightness
}


Printer()
{
  apt-get install cups cups-pdf hplip

  lsusb
  hp-plugin -i
  hp-setup -i
}


Package()
{
  Log "$0->$FUNCNAME"

  #ExecM  "apt-get update"			"Update repository list"
  #ExecM "Update packages and kernel"		"apt-get dist-upgrade"
  #ExecM "Install package MC"			"apt-get install mc"
  #ExecM "Remove completely package MC"		"apt-get --purge remove mc"
  #ExecM "Reconfigure package MC"		"apt-get --purge remove mc"
  #ExecM "Get packages list" 			"dpkg -l"

  #apt-get clean
  #ppa-purge ppa:repository-name/subdirectory
}


Kernel()
{
  Log "$0->$FUNCNAME"

  #ExecM "current kernel"	"uname -r"
  #ExecM "Availabe kernels"	"dpkg --list | grep --color=auto linux-image"
}



File()
{
  Log "$0->$FUNCNAME"

  #ExecM "Delete files by mask" "find /var/run -type f -iname 'pid' -delete"
}


Process()
{
  Log "$0->$FUNCNAME"

  # startup services
  rcconf
  sysv-rc-conf
  service --status-all

  ExecM "Processes tree" 	"pstree"
  ExecM "Process grep"   	"pgrep dhclient"
  ExecM "Top scrolled"   	"htop"
  ExecM "LOaded services"  	"initctl list"

  ExecM "Start service"	service apparmor start
  ExecM "Stop service"		service apparmor stop

  ExecM "Show autoload list" service --status-all

  ExecM "Add package `apparmor` from autoload"		"update-rc.d apparmor defaults"
  ExecM "Del package `apparmor` from autoload"		"update-rc.d -f apparmor remove"
}


User()
{
  Log "$0->$FUNCNAME"

  #ExecM "Connect user to `sudo` group"		"usermod -a -G sudo VladVons"
  #useradd VladVons --groups sudo --force-badname
  printenv
}


Net()
{
  Log "$0->$FUNCNAME"

  nm-tool
  hostname -f
  
  ExecM "sudo nmap -PN -sN 192.168.2.2 -p 5900" "check host for port opened"
  ExecM "nmap -sP 192.168.2.0/24" "scan network for devices"
  ExecM "ifconfig eth0 down && ifconfig eth0 up" "reconnect interface"
}


EchoEOF()
{
  cat <<- MyEOF
This is long multiline "quotas" example " <brackets>" {br}.
This is for fun.
MyEOF
}


Ruspberry()
{
  Log "$0->$FUNCNAME"
  
  # stress test utils
  # http://www.roylongbottom.org.uk/Raspberry%20Pi%20Stress%20Tests.htm    

  # write OS imsge to SD card
  # ddrescue -d -D --force ubuntu-mate-15.04-desktop-armhf-raspberry-pi-2.img /dev/sdX

  # configure raspberry     
  # raspi-config
  # dpkg-reconfigure locales | tzdata | keyboard-configuration | console-setup

  # temperature
  # vcgencmd measure_temp
  # vcgencmd get_mem gpu
  # vcgencmd get_mem arm

  awk '/^Serial\s*:\s/{print $3}' /proc/cpuinfo
  cat /proc/cpuinfo | grep -i Serial | awk ' {print $3}'

  # upgrade core
  apt-get update  
  apt-get upgrade
  rpi-update

  # dpkg -l | grep -i java

  # get debug library location
  # find /usr/lib | grep -i tools.jar

  # no need to install. Its by default 
  # apt-get install default-jdk default-jre default-jre-headless  

  # update from default version 6 to 7
  # apt-get remove openjdk-6-jre openjdk-6-jre-headless openjdk-6-jre-lib --purge
  # apt-get remove gcj-4.7-jre gcj-4.7-jre-headless gcj-4.7-jre-lib gcj-jre-headless --purge
  #
  # apt-get install openjdk-7-jre openjdk-7-jre-headless openjdk-7-jre-lib openjdk-7-jdk
  # apt-get autoremove

  # small
  # icedtea-7-jre-jamvm
  # icedtea-7-jre-cacao

  # by default installed
  # apt-get install openjdk-6-jre
  java  -version

  # compiler 
  # apt-get install openjdk-7-jdk
  # javac -version

  # install pi4j library. Method 1
  # curl -s get.pi4j.com | sudo bash

  # install pi4j library. Method 2
  # wget http://get.pi4j.com/download/pi4j-1.0.deb
  # dpkg -i pi4j-1.0.deb

  javac -classpath .:classes:/opt/pi4j/lib/'*' Test1.java
  java  -classpath .:classes:/opt/pi4j/lib/'*' Test1


  # Soft
  # apt-get install epiphany-browser
}


SysBench()
{

  # CPU
  sysbench --test=cpu --cpu-max-prime=20000 run

  # MySQL
  sysbench --test=oltp --oltp-table-size=1000000 \
           --mysql-db=app_front_office --mysql-user=$gMySQLUser --mysql-password=$gMySQLPassw \
           --max-time=60 --oltp-read-only=on --max-requests=0 --num-threads=8 run
}


ForkBumb()
{
  # edit limits file /etc/security/limits.conf and relogin 
  # username soft nproc 500
  # username hard nproc 1000

  #get current user limits
  ulimit -u

  #count running processes for all users 
  ps hax -o user | sort | uniq -c

  #count running processes for root users 
  ps aux | grep root | wc -l
}

Splash()
{
  Log "$FUNCNAME"
  
  #SysInstall "plymouth-theme-script" "Startap splash"
  
  Theme="Win7"
  
  Dir="/lib/plymouth/themes"
  File=$(ls $Dir/$Theme/*.plymouth)
  
  update-alternatives --install $Dir/default.plymouth default.plymouth $File 100
  update-alternatives --config default.plymouth
  update-initramfs -u
}



clear
case $1 in
    Device)           $1 ;;
    Package)          $1 ;;
    File)             $1 ;;
    Process)          $1 ;;
    Kernel)           $1 ;;
    EchoEOF)          $1 ;;
    SysBench)         $1 ;;
esac
