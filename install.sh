#!/bin/bash
# Created by didiatworkz

_ANSIBLE_VERSION=4.9.0
_BRANCH=v3.2
#_BRANCH=master


header() {
tput setaf 172
cat << "EOF"
                            _
   ____                    | |
  / __ \__      _____  _ __| | __ ____
 / / _` \ \ /\ / / _ \| '__| |/ /|_  /
| | (_| |\ V  V / (_) | |  |   <  / /
 \ \__,_| \_/\_/ \___/|_|  |_|\_\/___|
  \____/                www.atworkz.de

EOF
echo
echo "Screenly OSE Monitor Add-On (SOMA)"
echo
echo
tput sgr 0
}

clear
header
echo ""
echo -e "[ \e[32mSOMA\e[39m ] Start Add-on installation..."
sleep 2

curl -s https://bootstrap.pypa.io/get-pip.py | sudo python3

if [ ! -e /home/pi/screenly/server.py ]
then
  echo -e "[ \e[32mSOMA\e[39m ] ScreenlyOSE not installed!"
  sudo mkdir -p /etc/ansible
  echo -e "[local]\nlocalhost ansible_connection=local" | sudo tee /etc/ansible/hosts > /dev/null
  echo -e "[ \e[32mSOMA\e[39m ] Install ansible..."
  sudo apt update
  sudo apt-get purge -y python-setuptools python-pip python-pyasn1 libffi-dev
  sudo apt-get install -y python3-dev git-core libffi-dev libssl-dev
  sudo pip3 install ansible=="$_ANSIBLE_VERSION"
  echo -e "[ \e[32mSOMA\e[39m ] Install ansible...DONE"
  

else
  echo -e "[ \e[32mSOMA\e[39m ] ScreenlyOSE installed!"
fi

echo -e "[ \e[32mSOMA\e[39m ] Check if nginx server installed..."
if command -v nginx &> /dev/null
then
    echo -e "[ \e[32mSOMA\e[39m ] nginx server found!"
    FILE=/home/pi/screenly/server.py
    if [ -f "$FILE" ]; then  
        echo -e "[ \e[32mSOMA\e[39m ] ScreenlyOSE installed"
        echo -e "[ \e[32mSOMA\e[39m ] Check if ScreenlyOSE use docker..."
        DOCK_IMAGE=$(docker images -q screenly/srly-ose-server)
        if [ -n "$DOCK_IMAGE" ]; then 
            echo -e "[ \e[32mSOMA\e[39m ] ScreenlyOSE use docker!"
            echo -e "[ \e[32mSOMA\e[39m ] Remove nginx..."
            sudo apt remove nginx-light -y

        else  
            echo -e "[ \e[32mSOMA\e[39m ] ScreenlyOSE use nginx server!"
            FILE=/etc/nginx/sites-enabled/soma_monout.conf
            if [ -f "$FILE" ]; then  
                echo -e "[ \e[32mSOMA\e[39m ] Remove old SOMA Add-on nginx configs..."
                sudo rm -rf /etc/nginx/sites-enabled/soma_monout.conf
                sudo rm -rf /etc/nginx/sites-enabled/soma_devinf.conf
                sudo systemctl restart nginx
            fi
        fi
    fi  
else 
    echo -e "[ \e[32mSOMA\e[39m ] No nginx server installed!"
fi
echo -e "[ \e[32mSOMA\e[39m ] Check if nginx server installed...DONE"

echo
echo
echo
echo -e "[ \e[32mSOMA\e[39m ] Clone SOMA Add-on repository from github -> branch: $_BRANCH"
sudo rm -rf /tmp/soma
sudo git clone --branch $_BRANCH https://github.com/didiatworkz/screenly-ose-monitoring-addon.git /tmp/soma
cd /tmp/soma
echo -e "[ \e[32mSOMA\e[39m ] Start ansible installation process..."
ansible-galaxy collection install community.general
sudo -E ansible-playbook addon.yml

header
echo -e "[ \e[32mSOMA\e[39m ] Add-on installation finished!"
echo -e "[ \e[32mSOMA\e[39m ] It is recommended to restart the device."
exit
