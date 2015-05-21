#!/usr/bin/python

import serial
from time import sleep

sp="/dev/ttyUSB0"
#sp="/dev/ttyUSB1"


s=serial.Serial(sp)

while True:
	sleep(0.5) # Time in seconds.
	s.setDTR(0)
	s.setRTS(0)
	sleep(0.5) # Time in seconds.
	s.setDTR(1)
	s.setRTS(1)