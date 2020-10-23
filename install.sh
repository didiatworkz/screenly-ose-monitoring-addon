#!/bin/bash
# Created by didiatworkz

_ANSIBLE_VERSION=2.9.9
_BRANCH=v2.0
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
echo "Prepair Screenly Player..."
sleep 2

if [ ! -e /home/pi/screenly/server.py ]
then
  echo -e "[ \e[32mNO\e[39m ] Screenly installed"
  echo -e "[ \e[93mYES\e[39m ] Standalone Installation"
  sudo mkdir -p /etc/ansible
  echo -e "[local]\nlocalhost ansible_connection=local" | sudo tee /etc/ansible/hosts > /dev/null
  sudo apt update
  sudo apt-get purge -y python-setuptools python-pip python-pyasn1 libffi-dev
  sudo apt-get install -y python3-dev git-core libffi-dev libssl-dev
  curl -s https://bootstrap.pypa.io/get-pip.py | sudo python3
  sudo pip3 install ansible=="$_ANSIBLE_VERSION"

else
  echo -e "[ \e[93mYES\e[39m ] Screenly installed"
fi

echo "The installation can may be take a while.."
echo
echo
echo
sudo rm -rf /tmp/soma
sudo git clone --branch $_BRANCH https://github.com/didiatworkz/screenly-ose-monitoring-addon.git /tmp/soma
cd /tmp/soma
sudo -E ansible-playbook addon.yml

header
echo "Screenly OSE Monitor addon successfuly installed"
