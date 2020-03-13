#!/usr/bin/lua5.3

for i = 1, 100 do

  d3 = i % 3 == 0
  d5 = i % 5 == 0

  if d3 and not d5 then print("Fizz") end
  if not d3 and d5 then print("Buzz") end
  if d3 and d5 then print("FizzBuzz") end
  if not d3 and not d5 then print(i) end

end
