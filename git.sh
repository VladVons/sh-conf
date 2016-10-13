#!/bin/bash

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

clear
case $1 in
    GitToServ|t)    GitToServ   "$2" "$3" ;;
    GitFromServ|f)  GitFromServ "$2" "$3" ;;
esac
