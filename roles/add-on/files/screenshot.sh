#!/bin/bash
# Screenly OSE Monitoring Add-on
cp /var/www/html/addon/loading.png /var/www/html/addon/screen/screenshot.png
sleep 40;
while true; do
   raspi2png --pngname /var/www/html/addon/screen/screenshot_tmp.png
   cp -f /var/www/html/addon/screen/screenshot_tmp.png /var/www/html/addon/screen/screenshot.png
   sleep 2;
done
exit
