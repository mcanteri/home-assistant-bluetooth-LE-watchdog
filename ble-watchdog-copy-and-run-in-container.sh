echo Copying file to container ...
docker cp ./bluetoothLE-watchdog.sh homeassistant:/usr/local/bin/
echo ... done.
docker exec -d homeassistant chmod 755 /usr/local/bin/bluetoothLE-watchdog.sh
echo Starting the watchdog ...
docker exec -d homeassistant /usr/local/bin/bluetoothLE-watchdog.sh
echo ... done.
