#!/bin/bash
#--- VladVons@gmail.co


#http://www.lissyara.su/?id=1167

source $DIR_ADMIN/conf/script/common.sh

AdminUser="VladVons"
AdminPassw="19710819DjycD"


Info()
# ------------------------
{
  Log "$0->$FUNCNAME"

  echo; echo "Check if admin is added:";
  net rpc group members "Domain Admins" -U $AdminUser%$AdminPassw

  echo; echo "Show domain groups:";
  net rpc group -U $AdminUser%$AdminPassw

  echo; echo "Show domain common info:";
  net rpc info -U $AdminUser%$AdminPassw

  echo; echo "Show registered computers:";
  net rpc group members "Domain Computers" -U $AdminUser%$AdminPassw

  echo; echo "Try to connect and see resources:";
  smbclient -L localhost -U $AdminUser%$AdminPassw
}


InitPDC()
# ------------------------
{
  Log "$0->$FUNCNAME"

  #http://forum.lissyara.su/viewtopic.php?f=3&t=4188&start=0&st=0&sk=t&sd=a&hilit=shells%3A+files
  #http://www.opennet.ru/base/net/samba_pdc_slackware.txt.html
  #http://www.lissyara.su/?id=1167

  echo; echo "Add unix groups:";
  pw groupadd ntAdmins
  pw groupadd ntUsers
  pw groupadd ntComputers

  echo; echo "ntAdmins must have minimum 1 user, so add it:";
  Users=$(pw groupshow ntAdmins | awk -F ':' '{print $4}')
  pw groupmod ntAdmins -M $Users,$AdminUser

  echo; echo "Map unix groups to domain:";
  net groupmap add ntgroup="Domain Admins"       unixgroup=ntAdmins      rid=512 type=d
  net groupmap add ntgroup="Domain Users"        unixgroup=ntUsers       rid=513 type=d
  net groupmap add ntgroup="Domain Guests"       unixgroup=nobody        rid=514 type=d
  net groupmap add ntgroup="Domain Computers"    unixgroup=ntComputers   rid=515 type=d

  echo; echo "Register admin with password in samba:";
  ( echo $AdminPassw; echo $AdminPassw ) | smbpasswd -s -a $AdminUser

  #echo; echo "Say SAMBA LDAP password:";
  #smbpasswd -w $AdminPassw


  echo; echo "Set all privilages to group Admins:";
  net rpc rights grant "Domain Admins" \
    SeMachineAccountPrivilege SeTakeOwnershipPrivilege SeBackupPrivilege SeRestorePrivilege \
    SeRemoteShutdownPrivilege SePrintOperatorPrivilege SeAddUsersPrivilege SeDiskOperatorPrivilege \
    -U $AdminUser%$AdminPassw

  echo; echo "see smb.conf section 'Members handling' for scripts"
  echo "Join domain with samba:";
  net join OSTER-PDC -U $AdminUser%$AdminPassw

  #echo; echo "Add computers to group (by default to 'Domain Computers'). Samba makes it automaticly"
  #AddMachinePDC OSTER-pc1
 
  Info
}


Shutdown()
# ------------------------
{
  CheckParam "$0->$FUNCNAME()" $# 0 0
  Log "$0->$FUNCNAME"
 
  /usr/local/etc/rc.d/samba restart &
}


AddMachine()
# ------------------------
{
 CheckParam "AddMachine(aMachine='$1')" $# 1 1
 aMachine=$1;
 Log "$0->$FUNCNAME"

 Dir="/home/samba/ntComputers/${aMachine}" 
 mkdir -p $Dir
 pw useradd "${aMachine}" -d $Dir -s /sbin/nologin -L "russian" -m -G ntComputers -c "Samba computer account"
}


AddMachinePDC()
# ------------------------
{
 CheckParam "AddMachinePDC(aMachine='$1')" $# 1 1
 aMachine="$1\$"; #machine name must followed with '$'

 AddMachine "${aMachine}"
 net rpc user add "${aMachine}" -U ${AdminUser}%${AdminPassw}
}


SetPrimGroup()
# ------------------------
{
 CheckParam "SetPrimGroup(aGroup='$1', aUser='$2')" $# 2 2
 aGroup=$1; aUser=$2;

 pw usermod $aUser -g $aGroup
}


DelUserFromGroup()
# ------------------------
{
 CheckParam "DelUserFromGroup(aGroup='$1', aUser='$2')" $# 2 2
 aGroup=$1; aUser=$2;
 
 Users=$(pw groupshow $aGroup | awk -F ':' '{print $4}')
 echo "Users in group $aGroup: $Users"
 NewUsers=$(echo "$Users" | awk -F $aUser '{print $1$2 }' | tr -s ',,' ',')
 echo "Users in group $aGroup: $NewUsers"

 pw groupmod $aGroup -M $NewUsers 
}


AddUserToGroup()
# ------------------------
{
 CheckParam "AddUserToGroup(aGroup='$1', aUser='$2')" $# 2 2
 aGroup=$1; aUser=$2;
 
 Users=$(pw groupshow $aGroup | awk -F ':' '{print $4}')
 echo "Users in group $aGroup: $Users"
 pw groupmod $aGroup -M $Users,$aUser 
}


DelGroup()
# ------------------------
{
 CheckParam "DelGroup(aGroup='$1')" $# 1 1
 aGroup=$1;
 
 pw groupdel $aGroup 
}


AddGroup()
# ------------------------
{
 CheckParam "AddGroup(aGroup='$1')" $# 1 1
 aGroup=$1;

 pw groupadd $aGroup
}


RenUser()
# ------------------------
{
 CheckParam "RenUser(aUserOld='$1', aUserNew=$2)" $# 2 2
 aUserOld=$1; aUserNew=$2; 
}
		
		
DelUser()
# ------------------------
{
 CheckParam "DelUser(aUser='$1')" $# 1 1
 aUser=$1; 
 
 Users=$(pw groupshow wheel | awk -F ':' '{print $4}')
 if [ ! $(echo $Users | grep $aUser) ]; then
    pw userdel $aUser -r
 fi   
}


AddUser()
# ------------------------
{
 CheckParam "AddUser(aUser='$1', aPasswd='$2')" $# 1 2
 aUser=$1; aPasswd=$2;
  
 Group="ntUsers" 
 HomeDir="/home/samba/${aUser}"
 pw useradd $aUser -d $HomeDir -s /sbin/nologin -L "russian" -m -g $Group -c "Samba user account"
 mkdir -p $HomeDir/.profiles
 chown $aUser:$Group $HomeDir/.profiles
 
 if [ "$aPasswd" ]; then
    ( echo $aPasswd; echo $aPasswd ) | smbpasswd -s -a $aUser
 fi    
}
     

Default()
# ------------------------
{
 CheckParam "Default(a1='$1', a2='$2')" $# 0 0

 echo "Unknown command: '$1'" 
}



case $1 in
    AddUser)		$1 $2 $3 ;;
    DelUser)		$1 $2 $3 ;;
    RenUser)		$1 $2 $3 ;;
    AddGroup)		$1 $2 $3 ;;
    DelGroup)		$1 $2 $3 ;;
    AddUserToGroup)	$1 $2 $3 ;;
    DelUserFromGroup)	$1 $2 $3 ;;
    SetPrimGroup)	$1 $2 $3 ;;
    AddMachine)		$1 $2 $3 ;;
    AddMachinePDC)	$1 $2 $3 ;;
    Shutdown)		$1 $2 $3 ;;
    Info)		$1 $2 $3 ;;
    *)			Default $2 $3 ;;
esac
         
