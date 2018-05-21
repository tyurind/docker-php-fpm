#!/bin/bash

#####################################
# PYTHON:
#####################################

rm -rf /usr/bin/pip /usr/bin/pip2

#apt-get update -yqq
#apt-get -qy install python python-pip
# apt-get install -qy python-dev build-essential

install_clean python python-pip

# && pip install --upgrade pip
# && pip install --upgrade virtualenv
. ~/.bashrc

#pip install --upgrade pip
pip install redis

rm -rf /root/.cache/pip

install_clean

