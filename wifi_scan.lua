function listap(t)
 for k,v in pairs(t) do
    print(k.." : "..v)
 end
end
wifi.setmode(wifi.STATION)
wifi.sta.getap(listap)
print("\r\nscanning. . .")
