#! /bin/bash

# Need to run this script as root!
if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

# Install python 3.4.
yum install python34
yum install PyQt4
yum install PyQt4-webkit


# Get the pip install script and run it.
curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py

# Get the required packages.
pip2.6 install bs4 request
pip3.4 install requests yelp numpy pandas urllib3

