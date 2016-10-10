#!/bin/bash
#--- VladVons@gmail.com

# Ubuntu
# https://www.zeitgeist.se/2013/11/22/strongswan-howto-create-your-own-vpn/
# https://strongswan.org/testresults4.html

# Android
# https://strongswan.net/guides/android/



source ./const.sh
source $DIR_ADMIN/conf/script/system.sh


Host="tr24.oster.com.ua"
FileCaKey="$cDir/private/strongswanKey.pem"
FileCaCert="$cDir/cacerts/strongswanCert.pem"


KeyGen_CA()
# ------------------------
{
  Log "$0->$FUNCNAME"

  ExecM "ipsec pki --gen --type rsa --size 4096 --outform pem > $FileCaKey"
  ExecM "chmod 600 $FileCaKey"

  ipsec pki --self --ca --lifetime 3650 \
    --in $FileCaKey --type rsa \
    --dn "C=CH, O=strongSwan, CN=strongSwan Root CA" \
    --outform pem > $FileCaCert

  ExecM "ipsec pki --print --in $FileCaCert"
  ExecM "ls -1 $FileCaKey $FileCaCert"
}


KeyGen_Host()
# ------------------------
{
  Log "$0->$FUNCNAME"

  FileHostKey="$cDir/private/vpnHostKey.pem"
  FileHostCert="$cDir/certs/vpnHostCert.pem"

  ExecM "ipsec pki --gen --type rsa --size 2048 --outform pem > $FileHostKey"
  ExecM "chmod 600 $FileHostKey"

  ipsec pki --pub --in $FileHostKey --type rsa | \
    ipsec pki --issue --lifetime 730 \
    --cacert $FileCaCert \
    --cakey $FileCaKey \
    --dn "C=CH, O=strongSwan, CN=vpn.zeitgeist.se" \
    --san $Host \
    --flag serverAuth --flag ikeIntermediate \
    --outform pem > $FileHostCert

  ExecM "ipsec pki --print --in $FileHostCert"
  ExecM "ls -1 $FileHostKey $FileHostCert"
}


KeyGen_Client()
# ------------------------
{
  aName=$1; aMail=$2;
  Log "$0->$FUNCNAME, $aName, $aMail"

  LifeTime=1095 # 3 Years

  FileClientKey="$cDir/private/${aName}Key.pem"
  FileClientCert="$cDir/certs/${Name}Cert.pem"

  ExecM "ipsec pki --gen --type rsa --size 2048 --outform pem > $FileClientKey"
  ExecM "chmod 600 $FileClientKey"

  ipsec pki --pub --in $FileClientKey --type rsa | \
    ipsec pki --issue --lifetime $LifeTime \
    --cacert $FileCaCert \
    --cakey $FileCaKey \
    --dn "C=CH, O=strongSwan, CN=$aMail" \
    --san $aMail \
    --outform pem > $FileClientCert

  ExecM "ipsec pki --print --in $FileClientCert"
  ExecM "ls -1 $FileClient1Key $FileClientCert"

  KeyExport $FileClientKey $FileClientCert
}


KeyExport()
{
  aClientKey=$1; aClientCert=$2;
  Log "$0->$FUNCNAME, $aClientKey, $aClientCert"

  FileClientKeyExp="$aClientKey.p12"

  openssl pkcs12 -export \
    -inkey $aClientKey \
    -in $aClientCert \
    -name "Client1's VPN Certificate" \
    -certfile $FileCaCert \
    -caname "strongSwan Root CA" \
    -out $FileClientKeyExp

  ExecM "ls -1 $FileClientKeyExp"
}


KeyGen()
{
  Log "$0->$FUNCNAME"

  KeyGen_CA
  KeyGen_Host
  KeyGen_Client VladVons VladVons@gmail.com
}


NoKey()
{
  Log "$0->$FUNCNAME"
  #https://strongswan.org/testresults4.html
}

case $1 in
    KeyGen)		$1	$2 ;;
esac
