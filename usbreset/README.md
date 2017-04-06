usbreset

Simulate phisical disconnection of a usb device by software.

I need this software because sometime my usb ups connection hang, and I need to reset it, and the only way if I am not there was restart the raspbery...

From http://marc.info/?l=linux-usb&m=121459435621262&w=2

compile with

cc usbreset.c -o usbreset

instal with

cp usbreset /usr/local/bin

usage

sudo usbreset /dev/bus/usb/004/003

test with test.sh
