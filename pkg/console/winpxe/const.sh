#!/bin/bash
#--- VladVons@gmail.com

cApp="debootstrap"
cPkgName="$cApp"
cPkgAlso=""

cConf="lxde_a"
[ -f ./conf/default.conf ] && source ./conf/default.conf
