#!/bin/bash
#--- VladVons@gmail.com


SetAptSource()
{
  Log "$0->$FUNCNAME"

  Host="http://ua.archive.ubuntu.com/ubuntu"
  File="/etc/apt/sources.list"

  echo "#--- http://linux-ubuntu.info" > $File
  for Distr in ${cDistr} ${cDistr}-updates ${cDistr}-security; do
    echo "deb $Host $Distr main restricted universe multiverse" >> $File
  done;
}


AptCacher()
{
  Log "$0->$FUNCNAME"

  File="/etc/apt/apt.conf.d/01-MyProxy"
  if [ "$cAptCacherHost" ]; then
    echo "Acquire::http::proxy \"http://$cAptCacherHost:3142\";" > $File
  else
    echo "//nothing" > $File
  fi
}


StartA()
{
  Log "$0->$FUNCNAME"

  SetAptSource
  #AptCacher
  UserAddSudo "linux"
}


FinishA()
{
  Log "$0->$FUNCNAME"
}
