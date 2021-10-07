#!/bin/bash

# Checking bluetooth le from being stuck. Michele Canteri
# Write a trace on log file

ble_watchdog_log=/tmp/ble-watchdog.log
hci_proc=0
count=0
myDate=$(date +%C%g-%m-%d' '%H:%M:%S' INFO')
echo $myDate BluetoothLE Watchdog: starting ... >> $ble_watchdog_log

while true; do

	myDate=$(date +%C%g-%m-%d' '%H:%M:%S' INFO')
	myprocess_num=$(ps -e | grep hcitool | grep -v grep | awk {'print $1'})
	
	if [[ $hci_proc -eq $myprocess_num ]]; then
	
		if [[ $myprocess_num -eq "" ]]; then
			# The process is not running.
			count=$(expr $count + 1)
			echo $myDate BluetoothLE Watchdog: process not running, $count ... >> $ble_watchdog_log
			if [[ $count -gt 30 ]]; then
				echo $myDate BluetoothLE Watchdog: very likely the device need a reset or the system to reboot ... >> $ble_watchdog_log
				hciconfig hci0 reset
			fi
				
		else
			# Process stuck
			echo $myDate BluetoothLE Watchdog: fixing process $myprocess_num ... >> $ble_watchdog_log
			kill -1 $myprocess_num
			sleep 1
			hciconfig hci0 reset
		fi

	else

		# All is fine, different processes, normal behaviour
		echo $myDate BluetoothLE Watchdog: $myprocess_num, $hci_proc ... >> $ble_watchdog_log
		hci_proc=$myprocess_num
		# The counter can be cleared
		count=0

	fi
	
	echo $myDate BluetoothLE Watchdog: sleeping ... >> $ble_watchdog_log
	sleep 15

done
