--id=0
pinSDA=5
pinSCL=6 
--device_addr=0x20  
Value = 0; --0 to 1
value_min_step=0.1 
Saturation = 0; --0 to 1
HUE = 0; --0 to 360

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
  i2c.start(0)
  i2c.address(0, 0x52, i2c.TRANSMITTER) 
  i2c.write(0,0x40,0x00)
  i2c.stop(0)   
end


function NJ ()
  write_reg(0x52,0x00)
  reg = read_reg(0x52)
--read the buttons
--print("x" .. string.byte(reg, 1))
--print("y" .. string.byte(reg, 2))
   X_Value = string.byte(reg, 1)
   Y_Value = string.byte(reg, 2)
   X_Value = (X_Value-128)/128
   Y_Value = (Y_Value-128)/128
   --print (X_Value,Y_Value)
   --sat = laenge berechnen sqr(x²+y²)
   Saturation= (math.sqrt((X_Value*X_Value)+(Y_Value*Y_Value)))/1.4
    if Saturation>1 then
      Saturation=1
    end
   --print("sat",Saturation)
   
   --errechnen den hue winkel
    if X_Value >= 0 then --x positive
     if Y_Value >= 0 then --Q1
      HUE = math.atan(Y_Value/X_Value)
     else --q4
      HUE = math.atan(Y_Value/X_Value)+360
     end
    else --x negative ->q2 or q3 
      HUE = math.atan(Y_Value/X_Value)+180
    end
    print(HUE)
    HUE =HUE/360
   
   --Saturation = string.byte(reg, 1)
   --HUE = string.byte(reg, 2)
   if string.byte(reg, 6) == 0x1 then --upper button "c"
        if Value<(1-value_min_step) then
         Value=Value+value_min_step
        else
         Value=1        
        end
        print ("plus:", Value)
        --ws2812.writergb(7, string.char( 0,0,0, 0 , string.byte(reg, 1), string.byte(reg, 2) ))
    elseif string.byte(reg, 6) == 0x2 then --lower button "z"
        if Value>value_min_step then
         Value=Value-value_min_step
        else
         value=0        
        end
         print ("minus:", Value)
       --ws2812.writergb(7,string.char( string.byte(reg, 1), string.byte(reg, 2), 0, 0, 0, 0))
    elseif string.byte(reg, 6) == 0x0 then --both buttons
       
       print ("current value: ", Value)
       --print (Value)
       --ws2812.writergb(7, string.char(0, 0, 0, 0, 0, 0))    
    end
end

function timer_start(timer,intervall)
 tmr.alarm(timer, intervall, 1, function() NJ() end )
end

function timer_stop(timer)
 tmr.stop(timer)
end

--setup hardware
i2c.setup(0,pinSDA, pinSCL,i2c.SLOW) 

--nunchuck init
write_reg(0x52,{[0]=0x40,[1]=0x00})
write_reg(0x52,0x00)
--init done
tmr.delay(10)

-- Conversion start command
write_reg(0x52,0x00)
tmr.delay(10)

--read values
reg = read_reg(0x52)
print(string.len(reg))
print(reg)
print(string.byte(reg, 1))
print(string.byte(reg, 2))
print(string.byte(reg, 3))
print(string.byte(reg, 4))
print(string.byte(reg, 5))
print(string.byte(reg, 6))
