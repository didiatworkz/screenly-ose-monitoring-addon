#!/usr/bin/python3
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
#		    Device Info Version 1.3
#	________________________________________

import os
import psutil
import distro
import socket
from subprocess import check_output
from flask import Flask, url_for

_VERSION='1.3'
_HEADER='Screenly OSE Monitoring Add-On - Device Info V' + _VERSION

app = Flask('__name__')
#app.debug = True # Uncomment to debug

@app.route('/')
def home():
    return str(_HEADER)

@app.route('/check')
def check():
    return "true"

@app.route('/cpu')
def cpu():
    return str(psutil.cpu_percent())

@app.route('/cpu_frequency')
def cpu_frequency():
    cpu_frequency = psutil.cpu_freq()
    current = cpu_frequency.current
    return str(current)

@app.route('/disk')
def disk():
    disk = psutil.disk_usage('/')
    free = round(disk.free/1024.0/1024.0/1024.0,1)
    return str(free)

@app.route('/disk_total')
def disk_total():
    disk = psutil.disk_usage('/')
    total = round(disk.total/1024.0/1024.0/1024.0,1)
    return str(total)

@app.route('/disk_percent')
def disk_percent():
    disk = psutil.disk_usage('/')
    # Divide from Bytes -> KB -> MB -> GB
    # free = round(disk.free/1024.0/1024.0/1024.0,1)
    # total = round(disk.total/1024.0/1024.0/1024.0,1)
    return str(disk.percent)

@app.route('/help')
def help():
    func_list = {}
    output = ""
    for rule in app.url_map.iter_rules():
        if rule.endpoint != 'static':
            func_list[rule.rule] = app.view_functions[rule.endpoint].__doc__
    for value in func_list.keys():
        output += '%s <br />' % (value)
    return _HEADER + "<br /><br /><strong>Usable parameters:</strong><br />" + str(output)

@app.route('/hostname')
def hostname():
    output = socket.gethostname()
    return str(output)

@app.route('/memory')
def memory():
    memory = psutil.virtual_memory()
    free = round(memory.available/1024.0/1024.0,1)
    return str(free)

@app.route('/memory_total')
def memory_total():
    memory = psutil.virtual_memory()
    total = round(memory.total/1024.0/1024.0,1)
    return str(total)

@app.route('/model')
def model():
    modelFile = open("/proc/device-tree/model")
    model = modelFile.read()
    modelFile.close()
    return str(model)

@app.route('/platform')
def platform():
    output = distro.os_release_info()
    return str(output)

@app.route('/process')
def running_process_list():
    procs = {p.info for p in psutil.process_iter(['pid', 'name', 'username'])}
    return procs

@app.route('/system')
def uname():
    output = os.uname()
    return str(output)

@app.route('/temp')
def temp():
    tempFile = open("/sys/class/thermal/thermal_zone0/temp")
    cpu_temp = tempFile.read()
    tempFile.close()
    return str(int(cpu_temp.strip()) / 1000)

@app.route('/uptime')
def uptime():
    return str(psutil.boot_time())

@app.route('/version')
def version():
    return str(_VERSION)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9221)
