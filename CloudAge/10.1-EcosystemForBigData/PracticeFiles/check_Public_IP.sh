#!/bin/bash

#For Ubuntu

sudo apt install dnsutils

#For RedHat

#sudo yum install bind-utils

dig +short myip.opendns.com @resolver1.opendns.com
