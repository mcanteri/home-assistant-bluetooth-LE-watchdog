# home-assistant-bluetooth-LE-watchdog
A workaround about the buggy bluetooth LE implementation running on Home Assistant.
Usually when BLE discovery stop running is because the process doesn't end and remain stuck, so the daemon try to resolve the issue.

The script bluetoothLE-watchdog.sh is intended for who are running Home Assistant Supervised. 
Tested configuration:

version | core-2021.9.7
installation_type | Home Assistant Supervised
dev | false
hassio | true
docker | true
user | root
virtualenv | false
python_version | 3.9.7
os_name | Linux
os_version | 5.10.63-v7+
arch | armv7l

The script ble-watchdog-copy-and-run-in-container.sh is a partial work for injecting the watchdog into the container, for other kind of HA installation, but actually I don't know
if with HASSIO is possible to have access to docker on command line, so don't use it! Suggestion and help are welcome to improve the workaround.

How to run it
It need root privileges to try to resolve the issue (run hciconfig reset)
Copy the script bluetoothLE-watchdog.sh on your machine, i.e. in folder /root/bin/, and then run it as root sending it in background, like:

bluetoothLE-watchdog.sh &

You can have an idea of what is happening in the log file, under /tmp ;-)
