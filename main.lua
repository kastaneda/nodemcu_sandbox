gpio.mode(4, gpio.OUTPUT);

for i = 250000,50000,-10000
do
    gpio.write(4, gpio.LOW);
    tmr.delay(i);
    gpio.write(4, gpio.HIGH);
    tmr.delay(i);
end

dofile('simple_webserver.lua');