--id=0
pinSDA=5
pinSCL=6 
--device_addr=0x20  
--Value = 0; --0 to 1
--value_min_step=0.1 
--Saturation = 0; --0 to 1
--HUE = 0; --0 to 360

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

function NJ_test ()
  write_reg(0x52,0x00)
  reg = read_reg(0x52)
   x = string.byte(reg, 1)-128
   y = string.byte(reg, 2)-128
   print(math.wii(x,y))
  --print("x:" .. x.. " y:" .. y .. "->" .. math.wii(x,y))
--read the buttons
end



function timer_start(timer,intervall)
 tmr.alarm(timer, intervall, 1, function() NJ_test() end )
end

function timer_stop(timer)
 tmr.stop(timer)
end

--setup hardware
i2c.setup(0,pinSDA, pinSCL,i2c.SLOW) 

NJ_INIT()
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
