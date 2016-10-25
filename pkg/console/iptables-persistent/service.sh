#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
# ------------------------
{
  Test

  ExecM "iptables -L -v --line-numbers"
}


BlockGeoIP()
{
  # block IP by country
  PkgInstall "$cPkgGeoIP"

  # http://www.linuxcimber.net/howtos/geoip_on_ubuntu
  Dir1="/usr/share/xt_geoip"
  mkdir -p $Dir1
  /usr/lib/xtables-addons/xt_geoip_dl
  /usr/lib/xtables-addons/xt_geoip_build -D $Dir1 *.csv
  ExecM "rm GeoIP*" "remove downloaded files"

  ExecM "cat /proc/net/ip_tables_matches" "check if geoi recognized"
  #ExecM "module-assistant --verbose --text-mode auto-install xtables-addons" "adjust kernel"

  # block china (CN).
  # iptables -A INPUT -m geoip --src-cc CN -j REJECT

  # ???
  #File="worldip.iptables.tar.gz"
  #wget http://static.wipmania.com/static/$File
  #tar -xf $File -C /
  #rm $File
  #ln -s /var/geoip /usr/share/xt_geoip
}


InstallEx()
{
  Install
  BlockGeoIP
}


# ------------------------
clear
case $1 in
    Install)	InstallEx	$2 ;;
    *)		TestEx		;;
esac
