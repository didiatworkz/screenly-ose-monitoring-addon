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
#	     Screenly OSE Monitoring Add-On
#		      Monitor Output 1.0
#	________________________________________


from flask import Flask, send_file, redirect, url_for

_VERSION='1.0'

app = Flask('__name__')

#app.debug = True # Uncomment to debug
filename = 'output.png'

@app.route('/')
def home():
    return 'Screenly OSE Monitoring Add-on - Monitor Output V' + _VERSION

@app.route('/screen/screenshot.png')
def output():
    return send_file('/home/pi/soma/monitor-output/tmp/' + filename, mimetype='image/png')

@app.route('/show')
def show():
    return redirect(url_for('output'))

@app.route('/version')
def version():
    return str(_VERSION)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9220)
