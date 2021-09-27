#!/bin/bash

apt-get update

apt-get upgrade -y

apt-get dist-upgrade -y

do-release-upgrade -y

apt-get autoremove -y

apt-get autoclean
