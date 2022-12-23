FROM python:3.10-slim-buster

# Env vars used to configure the Hatch MQTT ini file
ENV ENV_HATCH_NAME=${ENV_HATCH_NAME:-hatch1}
ENV MQTT_HOST=${MQTT_HOST:-localhost}
ENV MQTT_PORT=${MQTT_PORT:-1883}
ENV HATCH_BTLE_MAC=${HATCH_BTLE_MAC:-'00:00:00:00:00:00'}

# By default, the password is not defined. This tells the Python logic to connect without authentication
ENV ENV_MQTT_USERNAME=${ENV_MQTT_USERNAME:-'homeassistant'}
ENV ENV_MQTT_PASSWORD=${ENV_MQTT_PASSWORD}

# Customizing these has not been tested
ENV MQTT_INI_TEMPLATE=${MQTT_INI_TEMPLATE:-mqtt.ini.template}
ENV MQTT_INI="${ENV_HATCH_NAME}_mqtt.ini"
ENV WORKING_DIR=${WORKING_DIR:-/app}

# Tell apt-get we're never going to be able to give manual feedback:
ARG DEBIAN_FRONTEND=noninteractive

# Update the package listing and install security updates, then clean up cache files and delete indexes that are no longer useful
# The build-essential and automake libs are required to support the bluepy library that is used
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y bluez dbus build-essential automake libglib2.0-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR $WORKING_DIR

COPY . .

# Install/build the project and initialize the scripts used to generate the config file
RUN pip3 install -r requirements.txt && \
    chmod +x run.sh && \
    chmod +x generate-mqtt-ini.sh

# Future goal:
# Run this to allow the bluetooth python library to run as non-root
# Source: https://github.com/southqaw/hatchrestbluepy
# More info: https://stackoverflow.com/questions/64061889/how-to-setcap-for-a-binary-file-in-docker-image
#RUN setcap 'cap_net_raw,cap_net_admin+eip' bluepy-helper
#USER hatch

CMD [ "./run.sh" ]
