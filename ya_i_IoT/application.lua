-- hardware, heh
gpio.mode(4, gpio.OUTPUT);
gpio.mode(1, gpio.INT, gpio.PULLUP)

-- init mqtt client without logins, keepalive timer 10s
m = mqtt.Client(node.chipid(), 10)
-- m = mqtt.Client("clientid", 10, "user", "password")

-- setup Last Will and Testament (optional)
-- Broker will publish a message with qos = 0, retain = 0, data = "offline"
-- to topic "/lwt" if client don't send keepalive packet
m:lwt("/test", "esp8266 offline", 0, 0)

m:on("connect", function(client) print ("connected") end)
m:on("offline", function(client) print ("offline") end)

-- on publish message receive event
m:on("message", function(client, topic, data)
  print(topic .. ":" )
  if data ~= nil then
    print(data)
    if data == "set_high"  then
      gpio.write(4, gpio.HIGH);
    end
    if data == "set_low"  then
      gpio.write(4, gpio.LOW);
    end
  end
end)

-- on publish overflow receive event
m:on("overflow", function(client, topic, data)
  print(topic .. " partial overflowed message: " .. data )
end)

-- for TLS: m:connect("192.168.0.38", secure-port, true)
m:connect("192.168.0.38", 1883, false, function(client)
  print("connected")
  -- Calling subscribe/publish only makes sense once the connection
  -- was successfully established. You can do that either here in the
  -- 'connect' callback or you need to otherwise make sure the
  -- connection was established (e.g. tracking connection status or in
  -- m:on("connect", function)).

  -- subscribe topic with qos = 0
  client:subscribe("/test/topic", 0, function(client) print("subscribe to /test/topic success") end)
  -- publish a message with data = hello, QoS = 0, retain = 0
  client:publish("/test", "esp8266 online", 0, 0, function(client) print("status sent to /test") end)
end,
function(client, reason)
  print("failed reason: " .. reason)
end)

-- onkeyup
gpio.trig(1, "up", function()
  print("button pressed");
  m:publish("/test", "button pressed", 0, 0)
end)
