#!/usr/bin/env bash

# Needed to make bluez work, source: https://medium.com/omi-uulm/how-to-run-containerized-bluetooth-applications-with-bluez-dced9ab767f6
# start services
service dbus start
service bluetooth start

# Generate the MQTT config file on the fly using env vars
./generate-mqtt-ini.sh

# Run the Hatch MQTT bridge client
echo "Launching python3 hatchmqtt.py --verbose --config ${MQTT_INI}"
python3 hatchmqtt.py --verbose --config ${MQTT_INI}
