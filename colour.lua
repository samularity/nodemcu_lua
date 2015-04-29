--id=0
pinSDA=5
pinSCL=6 
--device_addr=0x20  

--setup hardware
i2c.setup(0,pinSDA, pinSCL,i2c.SLOW) 
pinSDA=nil
pinSCL=nil


disp = u8g.ssd1306_128x64_i2c(0x3c)
disp:setFont(u8g.font_6x10)
disp:setFontRefHeightExtendedText()
disp:setDefaultForegroundColor()
disp:setFontPosTop()


function draw()
    local ip,_,_=wifi.sta.getip()
    disp:drawStr(0,0,"ESP IP: "..ip)
end
disp:firstPage()
repeat
    draw()

until disp:nextPage() == false


function write_reg(dev_addr,tx_bit)
  i2c.start(0)
  i2c.address(0, dev_addr, i2c.TRANSMITTER) 
  i2c.write(0,tx_bit)
  i2c.stop(0)   
end

function read_reg(dev_addr)
  i2c.start(0)
  i2c.address(0, dev_addr , i2c.RECEIVER)
  c=i2c.read(0,6)
  i2c.stop(0)
  return c
end

function NJ_INIT()
  write_reg(0x52,{[0]=0x40,[1]=0x00})
  write_reg(0x52,0x00)
  tmr.delay(5)--ms   --wait a little
end

function read_NJ()
   write_reg(0x52,0x00)
   reg = read_reg(0x52)
 print("x:" .. string.byte(reg, 1))
 print("y:" .. string.byte(reg, 2))
 print("bttn:" .. string.byte(reg, 6))
end

function NJ_test ()
  write_reg(0x52,0x00)
  reg = read_reg(0x52)
  x = string.byte(reg, 1)-128
  y = string.byte(reg, 2)-128
--  print("x:" .. x)
--  print("y:" .. y)
--   h       The hue
--   s       The saturation
--   v       The value
hue=math.wii(x,y)
Saturation= (math.sqrt((x*x)+(y*y)))/181
if Saturation>1 then
  Saturation=1
end

value=0.5--mit push switches
if string.byte(reg, 6) == 0x1 then --upper button 'c'
  value=value+0.4
elseif string.byte(reg, 6) == 0x2 then --lower button 'z'
  value=value-0.4
end

  hsvToRgb(hue, Saturation, value)
  
  --mem free
  Saturation=nil
  value=nil
  hue=nil
  x=nil
  y=nil
  collectgarbage("collect")
  collectgarbage()
  --print("x:" .. x.. " y:" .. y .. "->" .. math.wii(x,y))
end



function timer_start(timer,intervall)
 tmr.alarm(timer, intervall, 1, function() NJ_test() end )
end

function timer_stop(timer)
 tmr.stop(timer)
end

--nunchuck init
NJ_INIT()
timer_start(1,150)
-- Conversion start command
--write_reg(0x52,0x00)
--tmr.delay(10)

--read values
--reg = read_reg(0x52)
--print(string.len(reg))
--print(reg)
--print(string.byte(reg, 1))
--print(string.byte(reg, 2))
--print(string.byte(reg, 3))
--print(string.byte(reg, 4))
--print(string.byte(reg, 5))
--print(string.byte(reg, 6))




--
-- * Converts an HSV color value to RGB. Conversion formula
-- * adapted from http://en.wikipedia.org/wiki/HSV_color_space.
-- * Assumes h, s, and v are contained in the set [0, 1] and
-- * returns r, g, and b in the set [0, 255].
-- *
-- * @param   Number  h       The hue
-- * @param   Number  s       The saturation
-- * @param   Number  v       The value
-- * @return  Array           The RGB representation
--
function hsvToRgb(h, s, v)
  local r, g, b

  local i =math.floor(h * 6);
  
  local f = h * 6 - i;
  local p = v * (1 - s);
  local q = v * (1 - f * s);
  local t = v * (1 - (1 - f) * s);

  i = i % 6

  if i == 0 then r, g, b = v, t, p
  elseif i == 1 then r, g, b = q, v, p
  elseif i == 2 then r, g, b = p, v, t
  elseif i == 3 then r, g, b = p, q, v
  elseif i == 4 then r, g, b = t, p, v
  elseif i == 5 then r, g, b = v, p, q
  end
  r=r*255
  g=g*255
  b=b*255
 --      draw("R:" .. r ,0)
      -- draw("G:" .. b ,8)
     --  draw("B:" .. b ,16)

--    print("G: " .. g)
--    print("B: " .. b)
  ws2812.writergb(7, string.char(r,g,b,r,g,b))   
  return r * 255, g * 255, b * 255
end

