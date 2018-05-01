#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
# ------------------------
{
  Test

  echo
  NetStat "samba|smbd|nmbd|winbind"
  ExecM "pdbedit -L -v | grep Unix"
  ExecM "smbstatus"

  # ExecM "testparm"
  # ExecM "wbinfo -u" 

  #ExecM "nmblookup -S '*'" "search for WINS computers"
  ExecM "tail /var/log/kern.log"
}


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  mkdir -p $gDirSamba/{Public,Temp,Recycle}
  chmod 777 $gDirSamba/Temp

  mkdir -p /mnt/smb/tr24

 
  UName="Guest"
  UPassw="Guest"
  echo 'Add new user ' $UName
  AddUserSys $UName $UPassw -NS
  echo $UPassw | smbpasswd -a $UName -s

  #samba-tool user add USERNAMEE (Domain only)

  #change password for user
  #smbpasswd <UserName>

  #no talloc stackframe at ../source3/param/loadparm.c:4864, leaking memory
  #SOLVED
  #pam-auth-update
  #uncheck item "SMB password synchronization"
}


Remove()
{
  PkgRemove "samba samba-common smbclient libsmbclient"
}


Info()
{
  Log "$0->$FUNCNAME"

  MultiCall ManPrint $Man $gDirMan/$cApp
}


# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    Info)	$1	$2 ;;
    *)		TestEx	;;
esac
