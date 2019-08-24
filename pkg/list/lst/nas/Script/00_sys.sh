# VladVons@gmail.com

AddUsers()
{
    Log "$FUNCNAME"

    AddUserNoLogin guest  $UserGuestPassw
    AddUserNoLogin backup $UserBackupPassw
}


ResizeDisk()
{
    Log "$FUNCNAME"

    ROOT_DEV=$(findmnt / -o source -n)
    resize2fs $ROOT_DEV 2100M
    df -hT /dev/root
}


PreInstall()
{
    mkdir -p /mnt/{smb/temp,usb/data1}

    SetUserPassw root
    SetUserPassw pi

    dpkg-reconfigure locales
    dpkg-reconfigure tzdata

    AddUsers

    ResizeDisk
    Update
}
