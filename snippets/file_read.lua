-- open file in flash:
if file.open("init.lua") then
  print(file.read())
  file.close()
end

-- open 'init.lua', print the first line.
if file.open("init.lua", "r") then
  print(file.readline())
  file.close()
end

print(file.getcontents('welcome.txt'))
