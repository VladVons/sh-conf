#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/utils.sh


SetPassw()
{
  Log "$0->$FUNCNAME"

  echo "Password for user $User"
  htpasswd $DirConf/htpasswd $User
}

AsBackupUser()
{
  aHost=$1;

  CurUser=$(whoami)
  if [ $CurUser == $User ]; then
    UserHome=$(echo $HOME)
    echo "User:$User with home directory $UserHome"

    RsaFile="$UserHome/.ssh/id_rsa.pub"
    if [ ! -r $RsaFile ]; then
      ssh-keygen -t rsa
    fi

    # ??? doesnt ask handshake for a host
    echo "create dir for 'scp' on client $aHost"
    ssh -l root $aHost "mkdir -p /root/.ssh"

    echo "copy key file on client $aHost. Check also if owner is 'root'"
    #ssh-copy-id -i $RsaFile $User@$aHost
    scp -r $RsaFile root@${aHost}:/root/.ssh/authorized_keys

    echo "now is able to execute command without a password on cient $aHost"
    ssh -l root $aHost "ls -a"
    ssh -l root $aHost "whoami"
  else
    echo "must be run as $User user"
  fi
}


# ------------------------
clear
case $1 in
    AsBackupUser)	$1 $2 $3 ;;
    SetPassw)		$1 $2 $3 ;;
esac
