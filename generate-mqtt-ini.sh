#!/usr/bin/env bash

echo "Generating $MQTT_INI"
echo ""
echo "ENV_HATCH_NAME    = ${ENV_HATCH_NAME}"
echo "MQTT_HOST         = ${MQTT_HOST}"
echo "MQTT_PORT         = ${MQTT_PORT}"
echo "HATCH_BTLE_MAC    = ${HATCH_BTLE_MAC}"
echo "ENV_MQTT_USERNAME = ${ENV_MQTT_USERNAME}"
echo "ENV_MQTT_PASSWORD = ${ENV_MQTT_PASSWORD}"
echo "MQTT_INI_TEMPLATE = ${MQTT_INI_TEMPLATE}"
echo "MQTT_INI          = ${MQTT_INI}"

# MQTT_INI_BACKUP="$(date "+%Y%m%d.%H%M%S").$MQTT_INI"

# [ -f $MQTT_INI ] && (echo "$MQTT_INI exists already, moving to: $MQTT_INI_BACKUP" && cp -p $MQTT_INI $MQTT_INI_BACKUP)

cat $MQTT_INI_TEMPLATE | \
    sed -e "s/TEMPLATE_MQTT_HOST/${MQTT_HOST}/g" | \
    sed -e "s/TEMPLATE_MQTT_PORT/${MQTT_PORT}/g" | \
    sed -e "s/TEMPLATE_ENV_HATCH_NAME/${ENV_HATCH_NAME}/g" | \
    sed -e "s/TEMPLATE_HATCH_BTLE_MAC/${HATCH_BTLE_MAC}/g" > \
    $MQTT_INI && \
    echo "Setup $MQTT_INI for host=$MQTT_HOST, port=$MQTT_PORT, hatch name = $ENV_HATCH_NAME, and hatch MAC = $HATCH_BTLE_MAC"

