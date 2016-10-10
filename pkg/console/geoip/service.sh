#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


TestEx()
# ------------------------
{
  Test

  ExecM "geoiplookup mail.ru"
}


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"

  Pkg="Geo-IP-PurePerl-1.23"
  wget http://search.cpan.org/CPAN/authors/id/B/BO/BORISZ/$Pkg.tar.gz
  tar -zxf $Pkg.tar.gz
  cd $Pkg

  perl Makefile.PL
  make
  make test
  make install

  cd ..  
  rm -R $Pkg
  rm $Pkg.tar.gz  

  cpan install Geo::IP::PurePerl
}


Update()
# ------------------------
{
  Log "$0->$FUNCNAME"

  cd /tmp
  mkdir -p $DirOut

  wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
  wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
  wget http://www.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz

  gunzip -c GeoIP.dat.gz > ${DirOut}/GeoIP.dat
  gunzip -c GeoLiteCity.dat.gz > ${DirOut}/GeoIPCity.dat
  gunzip -c GeoIPASNum.dat.gz > ${DirOut}/GeoIPOrg.dat
}  


# ------------------------
clear
case $1 in
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    Update)	$1	$2 ;;
    *)		TestEx	;;
esac
