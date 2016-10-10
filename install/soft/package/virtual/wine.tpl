#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="wine1.7"
cPkgDepends="winetricks"
cDescr="Microsoft Windows emulator"
cTag="virtual,system"
cPpa="ppa:ubuntu-wine/ppa"
cUser="linux"

ScriptAfterInstall()
{
  exit

  # should be run as normal user 
  ExecUser "winetricks -q corefonts"	$cUser
  # ExecUser "winetricks tahoma"	$cUser # unknown host
  # ExecUser "winetricks lucida"	$cUser

  ExecUser "winetricks -q dcom98"	$cUser
  ExecUser "winetricks -q mfc42"	$cUser
  ExecUser "winetricks -q comctl32"	$cUser
  ExecUser "winetricks -q crypt32"	$cUser
  ExecUser "winetricks -q msxml6"	$cUser
  ExecUser "winetricks -q gdiplus"	$cUser
  ExecUser "winetricks -q winxp"	$cUser
  ExecUser "winetricks -q mdac28"	$cUser
  ExecUser "winetricks -q vb6run"	$cUser
  ExecUser "winetricks -q ie8"		$cUser
  ExecUser "winetricks -q d3dx9"	$cUser
  ExecUser "winetricks -q physx"	$cUser
}
