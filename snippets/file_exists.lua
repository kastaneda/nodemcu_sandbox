files = file.list()
if files["device.config"] then
    print("Config file exists")
end

if file.exists("device.config") then
    print("Config file exists")
end
