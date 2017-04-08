--- VladVons@gmail.com
# Created 02.02.2017

import os
import time
import machine
import network


def ConnectWLan(aESSID, aPassw):
    print('ConnectWLan')
    n = network.WLAN(network.STA_IF)
    n.active(True)
    n.connect(aESSID, aPassw)

    if (n.isconnected()):
        print('cant connect', aESSID, aPassw)
    else:
        print(n.ifconfig())


def ToggleLed():
    p2 = machine.Pin(2, machine.Pin.OUT)
    p2.value(not p2.value())


def FlashLed(aCount, aDelay):
    print('FlashLed')
    for i in range(0, aCount):
        print('i: ', i, aCount)

        ToggleLed()
        time.sleep(aDelay)
        ToggleLed()
        time.sleep(aDelay)


def Main():
    print('Main')

    ConnectWLan('R3-0976646510', '19710000')
    print()

    FlashLed(3, 0.5)
    print()

    print('Done')

#--------
Main()
