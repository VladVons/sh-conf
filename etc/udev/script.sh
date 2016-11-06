#!/bin/bash
#--- VladVons@gmail.com

#--- create file 70-persistent-net.rules
udevadm trigger --type=devices --action=add
sleep 3
cat /etc/udev/rules.d/70-persistent-net.rules
