#!/bin/bash
# Network Ups Tools to Thingspeak bash upload data scrtipt
# see result at https://thingspeak.com/channels/125287
# You need check your UPS data fields with
# upsc yourupsname@yourhost
# and substitute strings values with your ups values.
# I use only 7 fields but you could add the 8.
# Insert your Thingspeak upload key!
UPLOADKEY=SUBSTITUTE_WITH_YOUR_UPLOAD_KEY
# You must create the crons dir, and change with your user home if need
# or put the file where you wont
STATUSFILE=/home/pi/crons/status.txt
LOGFILE=/home/pi/crons/ups.log
# Substitute with your UPS value.
UPS=myups@localhost
# Change the value if need.
INVOLT_ST=input.voltage
OUTVOL_ST=output.voltage
INFREQ_ST=input.frequency
UPSTEMP_ST=ups.temperature
BATTERYVOLT_ST=battery.voltage
PERCENTU_ST=ups.load
PERCENTB_ST=battery.charge
NEWSTATUS_ST=ups.status
DATE=$(date)

INVOLT=$(upsc ${UPS} ${INVOLT_ST} 2>/dev/null )
if [ ${?} -eq 0 ]
then
        OUTVOLT=$( upsc ${UPS} ${OUTVOL_ST} 2>/dev/null )
        INFREQ=$( upsc ${UPS} ${INFREQ_ST} 2>/dev/null )
        UPSTEMP=$( upsc ${UPS} ${UPSTEMP_ST} 2>/dev/null )
        BATTERYVOLT=$( upsc ${UPS} ${BATTERYVOLT_ST} 2>/dev/null )
        PERCENTU=$( upsc ${UPS} ${PERCENTU_ST} 2>/dev/null )
        PERCENTB=$( upsc ${UPS} ${PERCENTB_ST} 2>/dev/null )
        NEWSTATUS=$( upsc ${UPS} ${NEWSTATUS_ST} 2>/dev/null )
        OLDSTATUS=$( cat ${STATUSFILE} )
        STATUS=${NEWSTATUS}
        if [ "${NEWSTATUS}" != "${OLDSTATUS}" ]
        then
                echo ${NEWSTATUS} ${DATE} >> ${LOGFILE}
                echo ${NEWSTATUS} > ${STATUSFILE}
        fi
#       echo $OUVOLT
#       echo $INVOLT
#       echo $INFREQ
#       echo $UPSTEMP
#       echo $BATTERYVOLT
#       echo $PERCENTU
#       echo $PERCENTB
        uscita=$(/usr/bin/curl -s http://api.thingspeak.com/update?key=${UPLOADKEY}\&field1=${INVOLT}\&field2=${INFREQ}\&field3=${OUTVOLT}\&field4=${PERCENTU}\&field5=${UPSTEMP}\&field6=${PERCENTB}\&field7=${BATTERYVOLT}\&status="${STATUS}" 2>/dev/null )
else
        STATUS="UPS comunication error"
        uscita=$(/usr/bin/curl -s http://api.thingspeak.com/update?key=${UPLOADKEY}\&status="${STATUS}" )
        echo ${STATUS} ${DATE} >> ${LOGFILE}
        # uncomment next lines if you have a usb intermittent problems connecting to ups, you nedd add 
	# Defaults:pi !requiretty 
	# in /etc/sudoers
        #DEVICE=$(lsusb -d 0665:5161)
	#BUS=$(echo ${DEVICE} | awk '{print $2}')
	#DEV=$(echo ${DEVICE} | awk '{print $4}')
        #sudo usbreset /dev/bus/usb/${BUS}/${DEV/:/} > /dev/null
	#sudo upsdrvctl stop > /dev/null
	#sudo upsdrvctl start > /dev/null
fi
