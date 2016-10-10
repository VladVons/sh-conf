#!/usr/bin/python

import re
import os

cLogFreeswitch = "/var/log/freeswitch/freeswitch.log"
cLogFail2ban   = "/var/log/fail2ban.log"

#http://stackoverflow.com/questions/3040716/python-elegant-way-to-check-if-at-least-one-regex-in-list-matches-a-string
def ParseFile(aFile, aRegExList):
    if not os.path.exists(aFile):
	print ("File not found: " + aFile)
	return

    Combined = "(" + ")|(".join(aRegExList) + ")"
    #print (Combined)

    FileH = open(aFile, "r")
    lines = FileH.readlines()
    Cnt = 0
    for line in lines:
	#print (line)
	matchObj = re.match(Combined, line)
	if matchObj:
            Cnt += 1 
	    print (str(Cnt) + ", " + matchObj.group())

    return


#RegStr = ".*\[WARNING\] sofia_reg\.c:\d+ Can't find user \[\d+@\d+\.\d+\.\d+\.\d+\] from.*"
#".*\[NO_ROUTE_DESTINATION\].*"
#ReIpMask = "\d+\.\d+\.\d+\.\d+"
#ReDigAtIpMask = "\d+@" + ReIpMask
#    ".*\[DEBUG\] sofia\.c:d+ sofia/external/d+@\d+\.\d+\.\d+\.\d+:\d+ receiving invite from 188.138.33.26:5071 version:.*"

# 192.168.2.1
RegIp4       = "\d+\.\d+\.\d+\.\d+"

# 192.168.2.1:5060
RegIp4Port   = RegIp4 + ":\d+"

# 123@192.168.2.1
RegIp4User = "\d+@" + RegIp4

# bc387f55-d6f1-47bf-9d43-5c36bc1c7e82
#RegSessionID    = "[0-9a-f]+\-[0-9a-f]+\-[0-9a-f]+\-[0-9a-f]+\-[0-9a-f]+"
RegSessionID    = "\w+\-\w+\-\w+\-\w+\-\w+"

# Digit repitation
# http://stackoverflow.com/questions/6507982/regex-to-find-repeating-numbers
RegDigitRep     = "(0{3,}|1{3,}|2{3,}|3{3,}|4{3,}|5{3,}|6{3,}|7{3,}|8{3,}|9{3,})"
#RegDigitRep     = "(2)\1+"

# 

RegStr = [
    #".*receiving invite from " + RegIpMaskPort + ".*",
    #".*Hangup sofia/external/" + RegAtIpMaskPort + " \[CS_ROUTING\] \[NO_ROUTE_DESTINATION\].*"
    #".*sofia/external/" + RegDigitRep + ".*"
    #".*find user \[\d+@\d+\.\d+\.\d+\.\d+\] from.*"
    #".*" + "find user" + ".*"
    ".*on sofia profile '\w+' for \[\d+@\d+.\d+.\d+.\d+\] from ip.*"
]



ParseFile(cLogFreeswitch, RegStr)
