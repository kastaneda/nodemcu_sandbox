NodeMCU playground
==================

Links:

 - https://nodemcu.readthedocs.io/en/master/getting-started/

Quick notes:

 - `java -jar ESPlorer.jar`
 - `=print(file.getcontents('init.lua'))`
 - GPIO 4 == LED (on my board)
    - HIGH means LED off
    - LOW means LED on
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
