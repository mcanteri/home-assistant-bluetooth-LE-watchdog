# home-assistant-bluetooth-LE-watchdog
A workaround about the buggy bluetooth LE implementation running on Home Assistant.
Usually when BLE discovery stop running is because the process doesn't end and remain stuck, so the daemon try to resolve the issue.

The script bluetoothLE-watchdog.sh is intended for who are running Home Assistant Supervised. 
Tested configuration:

<details><summary>Home Assistant currently tested</summary>
version | core-2021.9.7<br>
installation_type | Home Assistant Supervised<br>
dev | false<br>
hassio | true<br>
docker | true<br>
user | root<br>
virtualenv | false<br>
python_version | 3.9.7<br>
os_name | Linux<br>
os_version | 5.10.63-v7+<br>
arch | armv7l<br>
</details>

The script ble-watchdog-copy-and-run-in-container.sh is a partial work for injecting the watchdog into the container, for other kind of HA installation, but actually I don't know
if with HASSIO is possible to have access to docker on command line, so don't use it! Suggestion and help are welcome to improve the workaround.

How to run it<br>
It needs root privileges to try to resolve the issue (run hciconfig reset)<br>
Copy the script bluetoothLE-watchdog.sh on your machine, i.e. in folder /root/bin/, and then run it as root sending it in background, like:<br>

bluetoothLE-watchdog.sh &<br>

You can have an idea of what is happening in the log file, under /tmp ;-)
