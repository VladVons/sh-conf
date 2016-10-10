#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName=""
cPkgDepends="cups"
cDescr="Canon printer LBP series"
cTag="system,print"

Model="LBP2900" 
# LBP-810, LBP-1120, LBP-1210, LBP2900, LBP3000, LBP3010, etc


# http://help.ubuntu.ru/wiki/canon_capt
# https://help.ubuntu.com/community/CanonCaptDrv190#Ubuntu_12.04_Install


ScriptInstall()
{
  echo
  ## download driver. Extract 32 or 64 platform
  ## http://support-asia.canon-asia.com/contents/ASIA/EN/0100459601.html
  # dpkg -i cndrvcups-common_3.20-1_i386.deb cndrvcups-capt_2.70-1_i386.deb

  ## Turn printer off
  #/etc/init.d/cups restart
  #lpadmin -p $Model -m CNCUPS${Model}CAPTK.ppd -v ccp://localhost:59687 -E
  #ccpdadmin -p $Model -o /dev/usb/lp0
  #update-rc.d ccpd defaults

  #printer options
  #ccp://localhost:59687

  # reboot
}


ScriptRemove()
{
  ExecM "ccpdadmin -x $Model" "Unregister"
  ExecM "lpadmin -x $Model" "Unregister"

  ExecM "apt-get remove --purge cndrvcups-capt cndrvcups-common" "remove packages & conf"
  ExecM "update-rc.d -f ccpd remove" "remove auto boot service"
}
