#!/usr/bin/lua5.3

a = 1
b = 0

for i = 1, 10 do
  print(a)
  a, b = a + b, a
end
