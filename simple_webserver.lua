-- connect to WiFi access point
wifi.setmode(wifi.STATION)
station_cfg={}
station_cfg.ssid = "eq_guest"
station_cfg.pwd = "1234567890"
station_cfg.save = false
wifi.sta.config(station_cfg)

-- a simple HTTP server
srv = net.createServer(net.TCP)
srv:listen(80, function(conn)
    conn:on("receive", function(sck, payload)
        print(payload)
        sck:send("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n<h1> Hello, NodeMCU.</h1>")
    end)
    conn:on("sent", function(sck) sck:close() end)
end)

