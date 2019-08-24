# VladVons@gmail.com

AddUserSmb()
{
    aUser=$1; aPassw=$2;
    Log "$FUNCNAME, $aUser, $aPassw"

    AddUserNoLogin $aUser $aPassw
    echo -ne "$aPassw\n$aPassw\n" | smbpasswd -a -s $aUser
}


PostInstall()
{
    mkdir -p /mnt/usb/data1/share/{temp,work,recycle}

    AddUserSmb guest  $UserGuestPassw
    AddUserSmb backup $UserBackupPassw
}
