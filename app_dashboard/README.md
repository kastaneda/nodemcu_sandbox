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
/test                   some root namespace
    /boardXXXXXXXX      board root
        /led01          actuator
            /status     echo status
            /set        method to set
```
