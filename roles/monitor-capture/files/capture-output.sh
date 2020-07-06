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


_VERSION="2"
_WAIT_TIME="20"

echo "Screenshot Add-on for Screenly OSE Monitoring"
cp /home/pi/soma/monitor-output/booting.png /home/pi/soma/monitor-output/tmp/screenshot.png
echo "wait $_WAIT_TIME sec..."
sleep "$_WAIT_TIME";
echo "start screenshots..."
while true; do
   raspi2png --pngname /home/pi/soma/monitor-output/tmp/screenshot_tmp.png  || cp -f /home/pi/soma/monitor-output/error.png /home/pi/soma/monitor-output/tmp/screenshot_tmp.png
   cp -f /home/pi/soma/monitor-output/tmp/screenshot_tmp.png /home/pi/soma/monitor-output/tmp/screenshot.png
   sleep 3;
done
exit 0
