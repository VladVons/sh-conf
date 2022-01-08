#!/bin/bash


User="VladVons"
Mail="vladvons@gmail.com"
Url="https://github.com/$User/sh-conf.git"


GitAuth()
{
  # sign with eMail 1
  git config --global user.email $Mail
  git config --global user.name $User

  # no password.
  git config --global credential.helper 'cache --timeout=360000'
}


GitSyncToServ()
# sync only changes from disk to server.
{
  git status

  #git add install.sh
  #git rm TestClient.py
  #git mv README.md README
  #git log

  git add -u -v
  git commit -a -m "just commit"
  git push -u origin master
}

GitFromServ()
# sync changes from server to disk
{
  git pull
}

GitToServ()
# sync changes from disk to serv
{
  # add all new files
  git add -A -v
  GitSyncToServ
}

#mkdir -p /admin/conf && rsync --update --recursive --links tr24.oster.com.ua::AdminFull /admin/conf

clear
#GitAuth
case $1 in
    GitToServ|t)    GitToServ   "$2" "$3" ;;
    GitFromServ|f)  GitFromServ "$2" "$3" ;;
esac
