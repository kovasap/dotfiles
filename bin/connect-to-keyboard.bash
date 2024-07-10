#!/bin/bash

MAC='C6:4D:EC:B5:DA:B3'
bluetoothctl disconnect $MAC
bluetoothctl untrust $MAC
bluetoothctl remove $MAC
sleep 3
bluetoothctl connect $MAC
bluetoothctl pair $MAC
