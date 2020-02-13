pin=1

gpio.mode(pin, gpio.INPUT)
print(gpio.read(pin))

gpio.mode(pin, gpio.OUTPUT)
gpio.write(pin, gpio.HIGH)
gpio.write(pin, gpio.LOW)

-- Pull-up resistor
gpio.mode(pin, gpio.INPUT, gpio.PULLUP)

-- Interrupt mode
gpio.mode(pin, gpio.INT)
gpio.trig(pin, "up", function() print "rising edge" end)
