#!/bin/bash

MAC="D9:83:07:36:6D:CD"

bluetoothctl devices
bluetoothctl scan on
bluetoothctl pair $MAC
bluetoothctl trust $MAC
bluetoothctl connect $MAC                 
bluetoothctl pair $MAC  

# Turn off and on again if connected but not working.
