# VladVons@gmail.com

PreInstall()
{
    mkdir -p /mnt/{hdd/data1,usb}

    dpkg-reconfigure locales
    dpkg-reconfigure tzdata

    Update
}
