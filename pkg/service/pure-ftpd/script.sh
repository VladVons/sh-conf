#!/bin/bash
#--- VladVons@gmail.com


source $DIR_ADMIN/conf/script/system.sh


InitPAM()
# ------------------------
{
  Log "$0->$FUNCNAME"

  groupadd ftpgroup
  useradd -g ftpgroup -d /dev/null -s /etc ftpuser

  pure-pw useradd Guest -u ftpuser -d /home/Guest
  pure-pw passwd  Guest 
  #pure-pw userdel Guest

  pure-pw useradd 3w_revival -u ftpuser -d /home/hosting/active/3w_revival

}


AddUserNoLogin()
{
  aUser="$1";
  Log "$0->$FUNCNAME, $aUser"

  NoLogin="/usr/sbin/nologin"
  Shell="/etc/shells"
  grep -q -F $NoLogin $Shell || echo -e "\n$NoLogin" >> $Shell

  DirHome="/home/$aUser"
  mkdir -p $DirHome
  useradd $aUser --home-dir=$DirHome --shell=/usr/sbin/nologin
  passwd $aUser
  chown $aUser:$aUser $DirHome
  echo "Hello user $aUser" > $DirHome/hello.txt

  mkdir -p /home/ftp
  ln -s $DirHome /home/ftp 
}


# ------------------------
case $1 in
    InitPAM)            $1 $2 ;;
    AddUserNoLogin)     $1 $2 ;;
esac
