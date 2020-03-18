Web dashboard app
=================

JS SPA, working with Mosquitto WebSockets.

Features:

 - connect to Mosquitto server and listen
 - display sensor read value / actuator status
    - binary (on/off)
    - digital value
        - damn very big digit, or
        - round gauge with color scale and pointer
 - display delay since last sensor/actuator update
 - send commands to Mosquitto
    - toggle (on/off) status
 - log debug info and errors


Topic hierarchy
---------------

```
dk487                   some root namespace
    boardXXXXXXXX       board root
        led01           actuator (oh, really)
            dt          device will publish '0' or '1' here
            set         device will accept values '0' and '1' from this topic
        button01        sensor namespace
            dt          0/1
```

Sensor/actuator status: offline, online but not connected, online operated.
