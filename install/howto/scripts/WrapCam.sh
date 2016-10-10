#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua

# turn Webcam upside down when using skype,vlc etc 
# apt-get --yes install libv4-0

App=$1

# check if empty
[ "$App" ] || exit

# 32bit / 64bit has different path 
# File=$(locate v4l1compat.so)

Platform=$(uname -m)
if [ $Platform = "x86_64" ]; then
  File_V4l="/usr/lib/x86_64-linux-gnu/libv4l/v4l1compat.so"
else
  File_V4l="/usr/lib/i386-linux-gnu/libv4l/v4l1compat.so"
fi;

Str="$File_V4l $App"
echo $Str
LD_PRELOAD="$Str"
