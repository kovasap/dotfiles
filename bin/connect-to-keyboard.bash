#!/bin/bash

bluetoothctl devices
bluetoothctl scan on
bluetoothctl pair F9:32:58:CE:C8:8B
bluetoothctl trust F9:32:58:CE:C8:8B
bluetoothctl connect F9:32:58:CE:C8:8B                 
bluetoothctl pair F9:32:58:CE:C8:8B  

# Turn off and on again if connected but not working.
