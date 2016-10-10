#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


#http://support-au.canon.com.au/contents/AU/EN/0100270808.html
#http://www.canon.co.uk/support/consumer_products/product_ranges/printers/i_sensys/ 
# P.S.: Перед сканированием нажать кнопку(на самом МФУ) "Copy/scan" и выбрать "Удалённый сканер"!!! 

cPkgName=""
cPkgDepends_2="libbeecrypt7 beecrypt-dev libjpeg62 libglade2-0 libusb-dev"
cPkgDepends="xsane cups"
cDescr="Canon printer drivers and util"
cTag="system,print"


ScriptInstall()
{
  ExecM "adduser $gUser scanner" 
}