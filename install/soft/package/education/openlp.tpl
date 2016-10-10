#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="openlp"
cDescr="open source lyrics projection application for churches"
cTag="education,church"
AptList="/etc/apt/sources.list.d/$cPkgName.list"


ScripBeforeInstall()
{
  ExecM "echo deb http://ppa.launchpad.net/openlp-core/release/ubuntu trusty main > $AptList" 
  ExecM "echo deb-src http://ppa.launchpad.net/openlp-core/release/ubuntu trusty main >> $AptList"
}
