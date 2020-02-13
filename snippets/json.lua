ok, json = pcall(sjson.encode, {key="value"})
if ok then
  print(json)
else
  print("failed to encode!")
end

t = sjson.decode('{"key":"value"}')
for k,v in pairs(t) do print(k,v) end
