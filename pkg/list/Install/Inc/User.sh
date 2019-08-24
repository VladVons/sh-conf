# VladVons@gmail.com

AddUserNoLogin()
{
    aUser=$1; aPassw=$2;
    Log "$FUNCNAME, $aUser, $aPassw"

    useradd $aUser
    usermod --password $aPassw --shell /usr/sbin/nologin $aUser
}


SetUserPassw()
{
    aUser=$1;
    Log "$FUNCNAME, $aUser"

    passwd $aUser
}

