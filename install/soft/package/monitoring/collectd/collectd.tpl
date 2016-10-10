#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="collectd"
cPkgDepends="collectd-utils rrdtool hddtemp mbmon liboping0 lm-sensors"
cDescr="system monitoring tool"
cTag="system,monitoring"


ScripInstall()
{
  _PkgInstall "git"

  ExecM "git clone git://github.com/pommi/CGP.git /var/www/app/cgp"
  ExecM "ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled"
}
