#! /bin/bash

# Need to run this script as root!
if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

# Install python 3.4.
yum install python34

# Get the pip install script and run it.
curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py

# Get the required packages.
pip3.4 install requests


