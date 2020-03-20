-- Setup GPIO

-- Built-in LED
gpio.mode(4, gpio.OUTPUT)

-- Hardware button
-- gpio.mode(1, gpio.INT, gpio.PULLUP)

-- Init MQTT client connection w/o credentials, keepalive timer 10s
m = mqtt.Client(node.chipid(), 10)

-- Setup MQTT Last Will and Testament
m:lwt("test/common", "esp8266 board "..node.chipid().." offline", 0, 0)

m:on("offline", function(client) print ("Disconnected from MQTT broker") end)

m:on("message", function(client, topic, data)
  if (data == nil) then
    print("MQTT message, topic='"..topic.."', no data")
  else
    print("MQTT message, topic='"..topic.."', data='"..data.."'")
  end

  -- LED control
  if topic == "test/board"..node.chipid().."/led01/set" then
    if data == 1 or data == "1" then
      gpio.write(4, gpio.HIGH)
    end
    if data == 0 or data == "0" then
      gpio.write(4, gpio.LOW)
    end
  end

  -- Roll call
  if topic == "test/common/ping" then
    print("Ping request, sending pong")
    client:publish("test/common", "esp8266 board "..node.chipid().." pong", 0, 0)
  end
end)

-- on publish overflow receive event
m:on("overflow", function(client, topic, data)
  print("MQTT message, topic='"..topic.."', partial overflowed message: "..data )
end)

-- for TLS: m:connect("192.168.0.38", secure-port, true)
m:connect("192.168.0.38", 1883, false, function(client)
  print ("Connected to MQTT broker")
  client:subscribe("test/common/ping", 0)
  client:subscribe("test/board"..node.chipid().."/led01/set", 0)
  -- client:subscribe({["test/board"..node.chipid().."/led01/set"]=0,["test/common/ping"]=0})
  client:publish("test/common", "esp8266 board "..node.chipid().." online", 0, 0)
end,
function(client, reason)
  print("MQTT connection failed, reason: "..reason)
end)

-- Hardware button event: onKeyUp
-- gpio.trig(1, "up", function()
--   print("button pressed");
--   m:publish("test/button", "button pressed", 0, 0)
-- end)
