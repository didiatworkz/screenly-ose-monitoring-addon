#!/bin/bash
#                             _
#    ____                    | |
#   / __ \__      _____  _ __| | __ ____
#  / / _` \ \ /\ / / _ \| '__| |/ /|_  /
# | | (_| |\ V  V / (_) | |  |   <  / /
#  \ \__,_| \_/\_/ \___/|_|  |_|\_\/___|
#   \____/
#                  http://www.atworkz.de
#                        info@atworkz.de
#
# Screenly OSE Monitoring Add-on

_VERSION="2"
_WAIT_TIME="40"

while [[ $# -gt 0 ]] ; do
  case $1 in
    -h|-\?|--help)
      echo
			echo "Screenshot Add-on for Screenly OSE Monitoring."
      echo
			echo "With this add-on it is possible to create a screenshot of the current "
      echo "HDMI output and make it available at the address 0.0.0.0:9020."
			echo
			echo "Options: "
			echo "  --version | Show current installed version"
      echo
      exit 0
    ;;
    -v|--version)
			echo "$_VERSION"
      exit 0
    ;;
    *)
			echo "Invalid Option!"
      echo "Please enter --help for more commands"
      exit 1
    ;;
  esac
done

echo "Screenshot Add-on for Screenly OSE Monitoring"
cp /var/www/html/addon/booting.png /var/www/html/addon/screen/screenshot.png
echo "wait $_WAIT_TIME sec..."
sleep "$_WAIT_TIME";
echo "start screenshots..."
while true; do
   raspi2png --pngname /var/www/html/addon/screen/screenshot_tmp.png  || cp -f /var/www/html/addon/error.png /var/www/html/addon/screen/screenshot_tmp.png
   cp -f /var/www/html/addon/screen/screenshot_tmp.png /var/www/html/addon/screen/screenshot.png
   sleep 3;
done
exit 0
