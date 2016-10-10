#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="freeswitch"

cPkgName="$cApp"

cPkgDepends="freeswitch-sysvinit freeswitch-mod-event-socket freeswitch-meta-codecs freeswitch-mod-sofia \
freeswitch-mod-console freeswitch-mod-logfile \
freeswitch-mod-db freeswitch-mod-cdr-sqlite \
freeswitch-mod-lua freeswitch-mod-python freeswitch-mod-sndfile freeswitch-mod-sofia \
freeswitch-mod-xml-rpc freeswitch-mod-loopback freeswitch-mod-commands freeswitch-mod-dptools freeswitch-mod-expr freeswitch-mod-hash \
freeswitch-mod-dialplan-xml freeswitch-mod-native-file \
freeswitch-conf-vanilla \
freeswitch-mod-say-ru freeswitch-lang-ru"


#cPkgName="freeswitch-all"
#cPkgAlso="sqlite subversion flac sox vlc-data alsa-utils va-driver-all"
#svn checkout http://sipml5.googlecode.com/svn/trunk/ sipml5
#Tool: tshark wireshark

cProcess="$cApp"
cService="$gDirD/$cApp"
#cPort="5060|5080|5066|7443|8021"
cPort="5060"
cLog1="/var/log/$cApp/$cApp.log"

Dir2="/usr/share/$cApp/conf/vanilla"
DirMod="/usr/lib/freeswitch/mod"
DirRecord="/var/lib/freeswitch/recordings"

cDB_sql="/var/lib/freeswitch/db/cdr.db"
cDB_csv="/var/log/freeswitch/cdr-csv/Master.csv"

# Zoiper client download
# https://www.zoiper.com/en/voip-softphone/download/zoiper3#linux/step3

# https://freeswitch.org/confluence/display/FREESWITCH/NAT+Traversal
# https://wiki.freeswitch.org/wiki/Firewall
# http://www.voip-info.org/wiki/view/port+forwarding

