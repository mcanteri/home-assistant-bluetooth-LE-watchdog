#!/bin/bash

# Checking bluetooth le from being stuck. Michele Canteri
# Write a trace on log file

ble_watchdog_log=/tmp/ble-watchdog.log
hci_proc=0
count=0
myDate=$(date +%C%g-%m-%d' '%H:%M:%S' INFO')
echo "$myDate BluetoothLE Watchdog: starting ..." >> $ble_watchdog_log

while true; do

        myDate=$(date +%C%g-%m-%d' '%H:%M:%S' INFO')
        myprocess_num=$(pgrep hcitool)
        echo "$myDate BluetoothLE Watchdog: checking process $myprocess_num  ..." >> $ble_watchdog_log

        if [[ $hci_proc -eq $myprocess_num ]]; then

                if [[ $myprocess_num -eq "" ]]; then
                        # The process is not running.
                        count=$((1 + 10#$count))
                        echo "$myDate BluetoothLE Watchdog: process not running, $count ..." >> $ble_watchdog_log
                        if [[ $(("$(date "+%s")" - "$(date -d "$(grep "Previous execution of update_bluetooth is taking longer than the scheduled update" /usr/share/hassio/homeassistant/home-assistant.log | tail -1 | awk '{ print $1, $2 }')" "+%s")")) -lt 90 ]]; then
                                # We are having an error
                                hciconfig hci0 reset
                                echo "BT error 1, taking care of it!" >> $ble_watchdog_log
                        fi
                        if [[ $(("$(date "+%s")" - "$(date -d "$(grep "Unexpected error when scanning: Invalid device: Network is down" /usr/share/hassio/homeassistant/home-assistant.log | tail -1 | awk '{ print $1, $2 }')" "+%s")")) -lt 90 ]]; then
                                # We are having an error
                                hciconfig hci0 reset
                                echo "BT error 2, taking care of it!" >> $ble_watchdog_log
                        fi

                        if [[ $count -gt 50 ]]; then
                                echo "$myDate BluetoothLE Watchdog: something strange is happening, need investigation ..." >> $ble_watchdog_log
                        fi

                else
                        # Process stuck
                        echo "$myDate BluetoothLE Watchdog: fixing process $myprocess_num ..." >> $ble_watchdog_log
                        kill -1 "$myprocess_num"
                        sleep 3
                        hciconfig hci0 reset
                fi

        else

                # All is fine, different processes, normal behaviour
                echo "$myDate BluetoothLE Watchdog: $myprocess_num, $hci_proc ..." >> $ble_watchdog_log
                hci_proc=$myprocess_num
                # The counter can be cleared
                count=0

        fi

        echo "$myDate BluetoothLE Watchdog: sleeping ..." >> $ble_watchdog_log
        sleep 15

done
