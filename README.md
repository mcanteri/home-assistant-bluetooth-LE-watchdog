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

You can have an idea of what is happening in the log file, under /tmp ;-)<br>

My Hardware configuration is as follow:<br>
hci1:   Type: Primary  Bus: UART<br>
        BD Address: B8:27:EB:79:B9:EA  ACL MTU: 1021:8  SCO MTU: 64:1<br>
        UP RUNNING INQUIRY<br>
        RX bytes:5545374 acl:1 sco:0 events:56932 errors:0<br>
        TX bytes:246693 acl:2 sco:0 commands:19113 errors:0<br>
        Features: 0xbf 0xfe 0xcf 0xfe 0xdb 0xff 0x7b 0x87<br>
        Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3<br>
        Link policy: RSWITCH SNIFF<br>
        Link mode: SLAVE ACCEPT<br>
        Name: 'xxx.yyy.org'<br>
        Class: 0x0c0000<br>
        Service Classes: Rendering, Capturing<br>
        Device Class: Miscellaneous,<br>
        HCI Version: 5.0 (0x9)  Revision: 0x156<br>
        LMP Version: 5.0 (0x9)  Subversion: 0x6119<br>
        Manufacturer: Cypress Semiconductor Corporation (305)<br>
<br>
hci0:   Type: Primary  Bus: USB<br>
        BD Address: 00:1A:7D:DA:71:13  ACL MTU: 310:10  SCO MTU: 64:8<br>
        UP RUNNING<br>
        RX bytes:64136505 acl:0 sco:0 events:1939753 errors:0<br>
        TX bytes:45520 acl:0 sco:0 commands:5022 errors:0<br>
        Features: 0xff 0xff 0x8f 0xfe 0xdb 0xff 0x5b 0x87<br>
        Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3<br>
        Link policy: RSWITCH HOLD SNIFF PARK<br>
        Link mode: SLAVE ACCEPT<br>
        Name: 'xxx.yyy.org #1'<br>
        Class: 0x0c0000<br>
        Service Classes: Rendering, Capturing<br>
        Device Class: Miscellaneous,<br>
        HCI Version: 4.0 (0x6)  Revision: 0x22bb<br>
        LMP Version: 4.0 (0x6)  Subversion: 0x22bb<br>
        Manufacturer: Cambridge Silicon Radio (10)<br>
<br>
with two BT, the one integrated into RPi 3b+ and a USB dongle, both less than 5.1 bt version. The id 0 is configured for ble use and the id 1 for normal bt, as I use both modules in my config:<br>
<code>
# For bluetooth<br>
device_tracker:<br>
  - platform: bluetooth_tracker<br>
    device_id: 1<br>
    interval_seconds: 30<br>
    consider_home: 240<br>
    new_device_defaults:<br>
      track_new_devices: false<br>
  - platform: bluetooth_le_tracker<br>
    interval_seconds: 25<br>
    consider_home: 240<br>
    new_device_defaults:<br>
      track_new_devices: false<br>
</code>
