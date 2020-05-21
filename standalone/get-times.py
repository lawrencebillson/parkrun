#!/usr/bin/env python


import sys
import serial
serialport = serial.Serial("/dev/ttyUSB0", 9600, timeout=0.5)
while 1:
	response = serialport.readlines(None)
	if len(response) >= 2:
		print response[1].encode("hex") 		
                break
	
