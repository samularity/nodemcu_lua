function prepare()
     disp:setFont(u8g.font_6x10)
     disp:setFontRefHeightExtendedText()
     disp:setDefaultForegroundColor()
     disp:setFontPosTop()
end

local line = {}
for i=0, 5 do
      line[i] = ""
end

local function refresh_display()
    function draw()
        for i=0, 5 do
            if not  line[i] then line[i] = " " end
            disp:drawStr(0,11*i,line[i])
        end
    end 
    disp:firstPage()
    repeat
        draw()
    until disp:nextPage() == false
end


function get_time()
  local ip,_,_=wifi.sta.getip() 
  if not ip then  return("time: no ip"); end
  t = n.update()
  if not t then t = "NO TIME" end
  line[4]= string.format("time:" .. t)
end

function get_uptime()
   return string.format("up: %d s" , math.floor(tmr.now()/1000000) )
end

function get_heap()
  return string.format ("heap: %d" , node.heap())
end

function cycle_handler()
    print("tmr isr")
    line[1]=get_time()
    line[2]=get_heap()
    line[3]=get_uptime()
    refresh_display()
end

function auto_reconn()
    local ip,_,_= wifi.sta.getip() 
    if not ip then 
        print("no ip, try reconnect") 
        wifi.setmode(wifi.STATION)
        tmr.delay(10)
        wifi.sta.config("shack","welcome2shack")
        --wifi.sta.config("AndroidAP","1234567899")
        tmr.delay(1500)
        local ip,_,_=wifi.sta.getip() 
        if not ip then print("no wifi"); return; end
    end
    line[0]=ip;
    return  
end


--setup hardware
i2c.setup(0,5, 6,i2c.SLOW) 
disp = u8g.ssd1306_128x64_i2c(0x3c)


wifi.setmode(wifi.STATION)
wifi.sta.config("shack","welcome2shack")
--wifi.sta.config("AndroidAP","1234567899")

prepare() --lcd init
print("lcd init done")
tmr.delay(1500)
local ip,_,_=wifi.sta.getip() 
if not ip then ip = "NO IP on first try" end
line[0]="IP: " .. ip
print(line[0])
--line[1]="Uptimer: " .. string.format(" %d s" , (tmr.now()/1000000) )
--dofile("sntp.lc")
local n=require('sntp')
tmr.delay(450)
print("sntp require done")

tmr.alarm(2, 500, 1, cycle_handler)
--tmr.alarm(3, 2500, 1, auto_reconn)