#!/bin/bash

for MAC in 'F9:32:58:CE:C8:8B' 'D9:83:07:36:6D:C9'
do
    echo 'trying to connect to ' $MAC
    # bluetoothctl disconnect $MAC
    # bluetoothctl untrust $MAC
    # bluetoothctl remove $MAC
    sleep 2
    bluetoothctl trust $MAC
    bluetoothctl pair $MAC
    bluetoothctl connect $MAC
done
