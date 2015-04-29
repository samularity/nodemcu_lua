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

--setup hardware
i2c.setup(0,5, 6,i2c.SLOW) 
disp = u8g.ssd1306_128x64_i2c(0x3c)


wifi.setmode(wifi.STATION)
--wifi.sta.config("shack","welcome2shack")
wifi.sta.config("AndroidAP","1234567899")
prepare()
tmr.delay(450)
local ip,_,_=wifi.sta.getip() 
if not ip then ip = "NO IP" end
line[0]="IP: " .. ip
--line[1]="Uptimer: " .. string.format(" %d s" , (tmr.now()/1000000) )

dofile("sntp.lc")
tmr.delay(1500)
local n=require('sntp')
tmr.delay(450)
function get_time()
  local ip,_,_=wifi.sta.getip() 
  if not ip then return end
  t = n.update()
  if not t then t = "NO TIME" end
  line[4]= string.format("time:" .. t)
end
tmr.alarm(2, 1000, 1, function() refresh_display(); get_time(); line[2]=("heap:" .. node.heap());line[1]="Uptimer: " .. string.format(" %d s" , (tmr.now()/1000000) ); end)
