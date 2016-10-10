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


# ------------------------
case $1 in
    InitPAM)	$1	$2 ;;
esac
