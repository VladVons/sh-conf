#!/bin/bash
#--- VladVons@gmail.com


source $DIR_ADMIN/conf/script/utils.sh


UserFromSite()
{
  aSite="$1";

  Tail=""
  for i in $(echo $aSite | tr "-" "_" | tr "." "\n"); do
    Tail+=${i:0:1}
  done

  echo ${aSite%%.*}_${Tail} | tr "-" "_"
}


UserFromDir()
{
  aDir="$1";

  User=$(UserFromSite $(echo $aDir | sed 's/3w_//'))
  echo "3w_"${User}
}


SiteAdd()
{
  aSite="$1"; aPassw="$2"
  Log "$0->$FUNCNAME, $aSite, $aPassw"

  if [ -z "$aPassw" ]; then
    aPassw=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 10)
  fi;

  Dir="$gDirHosting/3w_${aSite}"
  User=$(UserFromSite $aSite)
  FtpUser="3w_$User"
  DbUser="3w_$User"
  DbPassw=${aPassw}m
  Date="$(date +%Y-%m-%d-%a), $(date +%H:%M:%S)"

  # Apache conf file
  cat file/3w_patern.conf | sed "s|pattern|${aSite}|g" > /etc/apache2/sites-enabled/3w_${aSite}.conf

  # Awstats conf file
  cat $DIR_ADMIN/conf/pkg/service/awstats/file/awstats.pattern.conf | sed "s|pattern|${aSite}|g" > /etc/awstats/awstats.${aSite}.conf

  # add user to system
  # --create-home
  ExecM "useradd $FtpUser --groups $gUser3w --home $Dir --shell /usr/sbin/nologin"
  echo ${FtpUser}:${aPassw} | chpasswd

  # www home directory init
  FileIndex="$Dir/public_html/index.php"
  if [ ! -r $FileIndex ]; then
    mkdir -p "$Dir/public_html"
    echo "<?php phpinfo(); ?>"> $FileIndex
    chown -R ${FtpUser}:${gUser3w} $Dir
  fi

  # create MySQL database
  source $DIR_ADMIN/conf/pkg/service/mysql-server/sql.sh
  dbCreateGrant "$FtpUser" "$User" "$DbPassw"

  # restart apache
  # $DIR_ADMIN/conf/pkg/service/apache2/service.sh e
  apachectl -k graceful

  # brief info for user

echo "
Site:      $aSite
Explorer:  $aSite/extpl
MyAdmin:   $aSite/phpmyadmin
Statistic: $aSite/awstats/awstats.pl
Path:      $Dir
Created:   $Date

FTP
User:      $FtpUser
Password:  $aPassw

MySQL
Database:  $FtpUser
User:      $User
Password:  $DbPassw

OpenCart
Admin:     $aSite/admin
User:      admin
Passw:     ---
" > $Dir/info.txt
}


UserInit()
{
  aUser="$1"; aDir="$2"; 

  #echo "$aUser, $aDir"
  #return

  if [ "$(UserExists $aUser)" ]; then 
    cmd="usermod"
  else
    cmd="useradd"
  fi

  ExecM "$cmd  $aUser --groups $gUser3w --home $gDirHosting/$aDir --shell /usr/sbin/nologin"
  DirSetOwnerPerm "$gDirHosting/$aDir" "${aUser}:${gUser3w}"
}


UsersInit()
# ------------------------
{
  Log "$0->$FUNCNAME, $gDirHosting"

  [ -z "$gDirHosting" ] && echo "Variable not found: gDirHosting" && exit
  [ ! -d "$gDirHosting" ] && echo "Directory not found: $gDirHosting" && exit

  ls -l $gDirHosting | grep "3w_" | awk '{ print $9 }' | \
  while read Dir; do
    echo
    #UserInit ${Dir%%.*} $Dir

    User=$(UserFromDir $Dir)
    UserInit $User $Dir
  done

  DirSetOwnerPerm "/var/www/lib" "${gUser3w}:${gUser3w}"
}


SetDirOwner()
# ------------------------
{
  aDir="$1";
  Log "$0->$FUNCNAME, $aDir"

  Path="$gDirHosting/$aDir"
  [ ! -d "$Path" ] && echo "Directory not found: $Path" && exit

  User=$(UserFromSite $aDir)
  UserInit $User $aDir
}



Backup()
# ------------------------
{
  Log "$0->$FUNCNAME" 

  #DirBackup $gDirHosting $gDirBackupHosting
  rsync --recursive --verbose --update --links $gDirHosting/* $gDirBackupHosting \
    --exclude=*/Temp/* --exclude=*/tmp/* --exclude=*/cache/* 
}


DelTemp()
# ------------------------
{
  Log "$0->$FUNCNAME" 

  if [ "$gDirHosting" ]; then
    DirClearMask "$gDirHosting -follow" Temp
    DirRemoveMask $gDirHosting "*.bak"
    rm /var/lib/php5/sessions/

    # file-1024x499.jpg, FireFox-150x150.png
    find $gDirHosting -type f -iregex '.*-[0-9]+x[0-9]+\.jpg'  -delete
    find $gDirHosting -type f -iregex '.*-[0-9]+x[0-9]+\.jpeg' -delete
    find $gDirHosting -type f -iregex '.*-[0-9]+x[0-9]+\.png'  -delete
  fi;
}


UsersList()
{
  Log "$0->$FUNCNAME"

  grep "^${gUser3w}" /etc/group
  echo

  ls -l $gDirHosting | grep "3w_" | awk '{ print $9 }' | \
  while read Dir; do
    Site=$(echo $Dir | sed 's/3w_//')
    User=$(UserFromDir $Dir)

    echo "$Dir $Site $User"
  done

}


DirSetPasswd()
{
  aUser=$1; aFile=$2;
  Log "$0->$FUNCNAME, $aUser, $aFile"  

  htpasswd -c $aFile $aUser
}


CheckHeader()
{
  url="oster.com.ua/Test/test.php"
  wget -S $url

  # firefox plugin
  # https://addons.mozilla.org/uk/firefox/addon/live-http-headers/
}

# ------------------------
clear
#SetDirOwner "3w_klaus.com.ua"
#UserFromDir 3w_klaus.com.ua
#UsersInit

case $1 in
    Exec)		$1 $2 $3 ;;
    DelTemp)		$1 $2 $3 ;;
    Backup)		$1 $2 $3 ;;
    DirSetPasswd)	$1 $2 $3 ;;
    SetDirOwner)	$1 $2 $3 ;;
    SiteAdd)		$1 $2 $3 ;;
    UserInit)		$1 $2 $3 ;;
    UsersInit)		$1 $2 $3 ;;
    UsersList)		$1 $2 $3 ;;
    CheckHeader)	$1 $2 $3 ;;
esac

