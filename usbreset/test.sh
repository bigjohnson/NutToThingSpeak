#!/bin/bash
# Change VENDOR and PRODUCT using your ups usb info
VENDOR=0665
PRODUCT=5161
DEVICE=$(lsusb -d ${VENDOR}:${PRODUCT})
echo ${DEVICE}
BUS=$(echo ${DEVICE} | awk '{print $2}')
DEV=$(echo ${DEVICE} | awk '{print $4}')
echo ${BUS}
echo ${DEV/:/}
ls /dev/bus/usb/${BUS}/${DEV/:/}
sudo usbreset /dev/bus/usb/${BUS}/${DEV/:/}
