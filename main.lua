gpio.mode(4, gpio.OUTPUT);

for i = 250000,50000,-50000
do
    gpio.write(4, gpio.LOW);
    tmr.delay(i);
    gpio.write(4, gpio.HIGH);
    tmr.delay(i);
end
