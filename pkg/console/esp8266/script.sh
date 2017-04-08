#!/bin/bash


UpdateFirmware()
{
  #Download micro-python image 
  #http://micropython.org/download#esp8266

  Url="http://micropython.org/resources/firmware/esp8266-20170108-v1.8.7.bin"
  File=${Url##*/}
  wget $Url

  #--- find plugged device. Ussual "/dev/ttyUSB0". Check if no
  #$DIR_ADMIN/conf/script/hard.sh GetNewDevices

  #---Flash ROM util. 
  pip install esptool
  #pip install --upgrade esptool

  # Connect USB cabel to first floor jack and new serial port shoult appear
  esptool.py --port /dev/ttyUSB0 erase_flash
  esptool.py --port /dev/ttyUSB0 --baud 460800 write_flash --flash_size=detect 0 $File
}

UpdateFile()
{
  # allow user 'linux' access serial port
  usermod -a -G dialout linux

  # install file deploy util
  pip install adafruit-ampy
  #pip install --upgrade adafruit-ampy

  # after reboot loader executes boot.py, main.py. So see what we have in root directory
  ampy --port /dev/ttyUSB0  --baud 115200 ls

  # show boot.py file
  ampy --port /dev/ttyUSB0  --baud 115200 get boot.py

  # try run and check for errors
  ampy --port /dev/ttyUSB0 --baud 115200 run main.py

  # if ok, write our main.py
  ampy --port /dev/ttyUSB0  --baud 115200 put main.py
}


Install()
{
  #http://docs.micropython.org/en/latest/esp8266/esp8266/tutorial/intro.html#deploying-the-firmware

  UpdateFirmware()
  UpdateFile()

  # connect to device.  CTRL-D soft reboot
  pip install pyserial picocom screen
  #screen $Dev 115200
  picocom --baud 115200 /dev/ttyUSB0


  #git clone https://github.com/micropython/webrepl.git
  #python webrepl_cli.py boot.py 192.168.4.1:/boot.py
 
  ###git clone https://github.com/pfalcon/esp-open-sdk.git

  #import webrepl_setup
  #press 'E' to enable 

  # to connect via Wi-Fi insert power cable to second floor
}


clear
case $1 in
    Install)		$1	$2 $3 ;;
esac
