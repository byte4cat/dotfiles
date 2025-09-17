#!/bin/bash

nmcli device disconnect wlan0
sleep 2
nmcli device connect wlan0
