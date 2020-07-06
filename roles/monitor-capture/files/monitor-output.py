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


import os
from flask import Flask, send_file

_VERSION='1.0'

from flask import Flask

app = Flask('__name__')

#app.debug = True # Uncomment to debug
filename = 'screenshot.png'

@app.route('/')
def home():
    return '<h1>Screenly OSE Monitoring Addon<h1><h2>Monitor Output 1.0<h2>'

@app.route('/screen/screenshot.png')
def output():
    return send_file('/home/pi/soma/monitor-output/tmp/' + filename, mimetype='image/png')

@app.route('/version')
def version():
    return str(_VERSION)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9020)
