#!/bin/bash

MAC="F9:32:58:CE:C8:8B"

bluetoothctl devices
bluetoothctl scan on
bluetoothctl pair $MAC
bluetoothctl trust $MAC
bluetoothctl connect $MAC                 
bluetoothctl pair $MAC  

# Turn off and on again if connected but not working.
