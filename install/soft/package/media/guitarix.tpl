#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="guitarix"
cDescr="Guitar sampler"
cTag="multimedia"


criptAfterInstall()
{
  #--- memory lock erro
  #https://askubuntu.com/questions/237793/guitarix-amp-simulator-failed-to-allocate-memory-jackd

  # stop pulsaudioa
  pulseaudio -k

  # real time 
  dpkg-reconfigure -p high jackd2

  # add user linux to audio group
  usermod -a -G audio linux

  # logout
  #reboot

  su $USER -c guitarix
}
 
