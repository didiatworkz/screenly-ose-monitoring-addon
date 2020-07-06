#!/bin/bash
#
#	                              _
#  	   ____                    | |
#	    / __ \__      _____  _ __| | __ ____
#	   / / _` \ \ /\ / / _ \| '__| |/ /|_  /
#  	| | (_| |\ V  V / (_) | |  |   <  / /
#  	 \ \__,_| \_/\_/ \___/|_|  |_|\_\/___|
#	    \____/
#
#			    http://www.atworkz.de
#			        info@atworkz.de
#	________________________________________
#	     Screenly OSE Monitoring Add-on
#		     Capture Output Version 2.0
#	________________________________________

raspi2png --pngname /home/pi/soma/monitor-output/tmp/screenshot_tmp.png  || cp -f /home/pi/soma/monitor-output/error.png /home/pi/soma/monitor-output/tmp/screenshot_tmp.png
cp -f /home/pi/soma/monitor-output/tmp/screenshot_tmp.png /home/pi/soma/monitor-output/tmp/screenshot.png

exit 0
