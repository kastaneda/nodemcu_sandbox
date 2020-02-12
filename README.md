NodeMCU playground
==================

Links:

 - https://nodemcu.readthedocs.io/en/master/getting-started/

Quick notes:

 - `java -jar ESPlorer.jar`
 - `=print(file.getcontents('init.lua'))`
 - GPIO 4 == LED (on my board)
    - HIGH means internal LED is off
    - LOW means internal LED is on
 - `dofile('main.lua');`
 - `=file.remove('main.lua');`
 - `=file.remove('main.lc');`
 - `while /bin/true; do read x; wget http://192.168.0.171/ -O -; done`
    - damn Chromium _always_ send two requests, to `/` and to `/favicon.ico`
 - `ab -n25 http://192.168.0.171/`
    - Requests per second:    39.88 [#/sec] (mean)
    - Time per request:       25.073 [ms] (mean)
    - Power consumption (measured on 5V USB port):
        - 80..100 mA while benchmarking
        - 30 mA on idle
 - `sudo apt install mosquito mosquito-clients`
 - `mosquitto_sub -h 127.0.0.1 -t "#" -v` (monitor all topics)
 - `mosquitto_pub -t "/test/topic" -m "Hello, world"` (just to test)
    - `mosquitto_pub -t /test/topic -m set_high`
    - `mosquitto_pub -t /test/topic -m set_low`

```
# press Enter to toggle LED
while /bin/true; do
read x; mosquitto_pub -t /test/topic -m set_low;
read x; mosquitto_pub -t /test/topic -m set_high; done
```

```
# make sound on each button click
stdbuf -oL -eL mosquitto_sub -t "#" | \
stdbuf -oL -eL grep "button pressed" | \
while read line; do \
play -q /usr/share/sounds/freedesktop/stereo/dialog-information.oga; done
```

Websockets
----------

```
# File /etc/mosquitto/conf.d/websockets.conf

# default one
port 1883

# extra
listener 9001
protocol websockets
```
