# Hatch Rest Home Assistant MQTT Bridge

This program allows an original [Hatch Rest](https://www.hatch.co/rest) to be controlled via BLE, through MQTT.
This program has support for Home Assistant MQTT auto discovery. The Hatch Rest will show up as a Switch component,
a Light component and a Fan component (for the sound machine part).

The recommended deployment is with Docker, but it is important to follow steps closely because of the inherent challenges
stemming from sharing the host's bluetooth with the container.

## Installation and Setup

Note: Bluetooth MAC can be obtained using a BLE scanner app – for example this
[BT Inspector](https://apps.apple.com/us/app/bluetooth-inspector/id1509085044) iOS app (noting that MAC = "serial number").
This app is unaffiliated and this should not be considered an endorsement. You can also use CLI tools like `bluetoothctl`.

It is recommended to clone this onto a host machine that is physically close to the Hatch device to ensure a strong
Bluetooth connection.

### Installation with Docker

* Make sure that `MQTT_HOST`, `MQTT_PORT`, `HATCH_BTLE_MAC`, and `ENV_HATCH_NAME` (as well as `ENV_MQTT_USERNAME` and
  `ENV_MQTT_PASSWORD` if using secure MQTT) are set in the `docker-compose.yaml` file or provided via an `env_file`
  named `.env` (ignored by `.gitignore`)
  * The `mqtt.ini.template` file is used to generate an `mqtt.ini` file inside the Docker container
    * By default, the name of `ini` file is `${ENV_HATCH_NAME}_mqtt.ini` when running with Docker
  * This `mqtt.ini` file is generated at runtime to provide maximum flexibility via use of environment variables.
  * The `.env` file should look like this:

    ```shell
    HATCH_BTLE_MAC='11:22:33:44:55:66'
    MQTT_HOST=127.0.0.1
    MQTT_PORT=1883
    ENV_HATCH_NAME=my_hatch

    ENV_MQTT_USERNAME=myuser
    ENV_MQTT_PASSWORD=super_secure_password
    ```

* Using Docker:
  * Build:

    ```shell
    docker build -t mikeoertli/hatch-mqtt-bridge:1.0.0 -t mikeoertli/hatch-mqtt-bridge:latest .
    ```

  * **UNTESTED** - Run locally (without `compose`):

    ```shell
    docker run -it --env-file=.env --net=host --cap-add=NET_ADMIN --name=hatch-mqtt-ha mikeoertli/hatch-mqtt-bridge:latest
    ```

    * The network type of `host` is required to share the host's bluetooth device.

  * Build and run the image with `docker-compose`:

    ```shell
    docker compose up --build -d --no-cache
    ```

### Installation without Docker

This is only intended to work on a Linux host. The underlying Hatch Bluetooth library
([hatchrestbluepy](https://github.com/southqaw/hatchrestbluepy)) and Bluetooth Python
([bluepy](https://github.com/IanHarvey/bluepy)) library it uses, are not intended to run on Windows or macOS hosts.

* Verify installation/setup steps for each of these prerequisites has been met.

  Namely:

  ```shell
  sudo apt install -y libglib2.0-dev
  ```

* Copy the `mqtt.ini.example` file to `mqtt.ini` (note that `mqtt.ini` is ignored in `.gitignore`)
  * Edit the various entries
  * If using a file name other than `mqtt.ini`, then make sure to set `MQTT_INI` to the new file name.
* Install the packages in `requirements.txt` with `pip3`
  * `pip3 install -r requirements.txt`
* Launch `hatchmqtt.py`, typically recommended to setup to launch at startup
  * Example launch command:

    ```shell
    python3 hatchmqtt.py \
      --debug \
      --config ${MQTT_INI} \
      --user=${ENV_MQTT_USERNAME} \
      --password=${ENV_MQTT_PASSWORD}
    ```

## Credits

[Klint Youngmeyer](https://github.com/southqaw/) (original implementation)

[Mike Oertli](https://github.com/mikeoertli) - Dockerization 
