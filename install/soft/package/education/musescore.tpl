#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="musescore"
cPkgDepends="git cmake g++"
cDescr="Sheet music notes editor"
cTag="education,music"


ScriptInstall()
{
  exit 

  ExecM "git clone git://github.com/musescore/MuseScore.git"
  ExecM "cd MuseScore"
  ExecM "make"
  ExecM "make install"
}