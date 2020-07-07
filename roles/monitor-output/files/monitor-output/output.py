#!/usr/bin/python
#
#	                            _
#	   ____                    | |
#	  / __ \__      _____  _ __| | __ ____
#	 / / _` \ \ /\ / / _ \| '__| |/ /|_  /
#	| | (_| |\ V  V / (_) | |  |   <  / /
#	 \ \__,_| \_/\_/ \___/|_|  |_|\_\/___|
#	  \____/
#
#			http://www.atworkz.de
#			   info@atworkz.de
#	________________________________________
#	     Screenly OSE Monitoring Addon
#		     Monitor Output 1.0
#	________________________________________


import subprocess
from flask import Flask, send_file

_VERSION='1.0'

from flask import Flask

app = Flask('__name__')

#app.debug = True # Uncomment to debug
filename = 'screenshot.png'

def capture_image():
    command = 'raspi2png --pngname /home/pi/soma/monitor-output/tmp/screenshot.png'
    p = subprocess.Popen(command, shell=True, stderr=subprocess.PIPE)

@app.route('/')
def home():
    return 'Screenly OSE Monitoring Add-on - Monitor Output V' + _VERSION

@app.route('/screen/screenshot.png')
def output():
    capture_image()
    return send_file('/home/pi/soma/monitor-output/tmp/' + filename, mimetype='image/png')

@app.route('/version')
def version():
    return str(_VERSION)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9020)
