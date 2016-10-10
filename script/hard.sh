#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua

source $DIR_ADMIN/conf/script/common.sh



CPU()
{
  Log "$FUNCNAME"

  ExecM "dmesg | grep -i cpu | grep -i Hz"
  ExecM "cat /proc/cpuinfo"
  ExecM "lscpu"
  ExecM "lshw -class processor"
  ExecM "dmidecode -t processor"
  ExecM "cpuid"
}


Mem()
{
  Log "$FUNCNAME"

  ExecM "dmesg | grep Memory"
  ExecM "grep MemTotal /proc/meminfo"
  ExecM "lshw -class memory"
  ExecM "dmidecode -t memory"
}


Webcam()
{
  Log "$FUNCNAME"

  ExecM "dmesg | egrep -i --color 'UVC|WebCam|Video'"
  ExecM "ls /dev/video*"
  ExecM "lshw -C multimedia"
  ExecM "vlc v4l:///dev/video0"

  ExecM "modprobe uvcvideo"
}


FireWare()
{
  # https://help.ubuntu.com/community/HowToCaptureDigitalVideo
  # ExecM "apt-get install --yes kino libavc1394-0 libraw1394-11 libraw1394-tools libavc1394-tools libdc1394-utils"

  # uncomment: /etc/modprobe.d/blacklist-firewire.conf
  # update-initramfs -k all -u 
  # reboot

  # Add user to Video group 
  # useradd -G video <UserName>
  ## /lib/udev/rules.d/50-udev-default.rules  

  # ln /dev/fw1 /dev/raw1394
  # kino

  ExecM "dmesg | egrep -i --color '1394|FireWare'"
  ExecM "lsmod | egrep -i --color '1394|FireWare'"
  ExecM "modprobe firewire_ohci"
  ExecM "ls /dev/fw*"
  ExecM "ls | grep 1394"
}


Video()
{
  Log "$FUNCNAME"

  ExecM "lshw -class display"
  ExecM "lspci | egrep -i --color 'vga|display|agp|3d|2d'"
  ExecM "dmesg | egrep -i --color 'vga|agp|3d|2d'"
  ExecM "dpkg -l | grep xorg | awk '{ print $2 }'" "xorg drivers as package"
  ExecM "ls -1 /usr/lib/xorg/modules/drivers" "Xorg drivers as modules"

  # reconfigure Xorg on linuxlite
  # service lightdm stop
  # Xorg -configure
  # cp /root/xorg.conf.new /etc/X11/	
}


Net()
{
  Log "$FUNCNAME"

  ExecM "lshw -C network"
  ExecM "lspci | egrep -i --color 'net|wlan'"
  ExecM "dmesg | egrep -i --color 'eth|wlan'"
  ExecM "ifconfig -a"
  ExecM "nm-tool"
  ExecM "ethtool -i eth0"
  ExecM "ethtool eth0"
}


Printer()
{
  ExecM "modprobe usblp"
  ExecM "ls -l /dev/usb/lp*"
  ExecM "ccpd start"
}


Scaner()
{
  #scanimage --batch --source="Automatic Document Feeder" -v -d "pixma:04A91728_1163AA" -v > test.tiff

  ExecM "lsusb"
  ExecM "scanimage -L"
  ExecM "scanimage -V"
  ExecM "scanimage -T"
  ExecM "sane-find-scanner"
  ExecM "ldconfig -v | grep libsane"

}


GetNewDevices()
# get list of new attached devices
# ------------------------
{
  ExecM "ls /dev/ > /tmp/dev_list_1.txt" "Dump current devices list"
  Wait "now plug in new device"
  ExecM "ls /dev/ > /tmp/dev_list_2.txt" "Dump updated devices list"
  ExecM "diff --suppress-common-lines -y  /tmp/dev_list_1.txt /tmp/dev_list_2.txt" "Compare two files"
}


UpdateWireless()
{
  Log "$FUNCNAME"

  ExecM "apt-get update --yes && apt-get dist-upgrade --yes" "update packages" 
  ExecM "apt-get install --reinstall --yes linux-image-$(uname -r)"
  ExecM "apt-get install --reinstall --yes bcmwl-kernel-source" "Wi-fi drivers rebuild"
  rmmod b43; rmmod bcma; rmmod wl; 
  modprobe wl; modprobe lib80211_crypt_tkip;
  ExecM "update-pciids" 
}


MakeTools()
{
  Log "$FUNCNAME" 

  ExecM "apt-get install --yes gcc make binutils git xorg-dev mesa-common-dev libdrm-dev libtool" "for recompile"
  ExecM "apt-get install --yes build-essential linux-headers-$(uname -r)" "rebuild core"
}


Test()
{
  update-pciids

  ExecM "lsb_release -a" "get ubuntu version"

  # ExecM "dpkg -l" "package list"

  # ExecM "parted -l" "partitions info" 
  # ExecM "blkid" "partitions ID"

  # Wi-Fi problem solving
  # iwconfig 
  # ExecM "nm-tool"  
  # rfkill list && rfkill unblock wlan
  # lshw -C network
  # cat /var/lib/NetworkManager/NetworkManager.state
  # ExecM "apt-get install --reinstall --yes linux-image-$(uname -r)"
  # ExecM "apt-get install --reinstall --yes bcmwl-kernel-source" "Wi-fi drivers rebuild"
  # ExecM "modprobe wl" "Wi-fi init"

  # Lenovo G30-G50
  # http://community.linuxmint.com/hardware/view/21090
}



clear
case $1 in
    CPU)		$1	$2 ;;
    Mem)		$1	$2 ;;
    GetNewDevices)	$1	$2 ;;
    Net)		$1	$2 ;;
    Video)		$1	$2 ;;
    Webcam)		$1	$2 ;;
    *)			Help	$2 ;;
esac
