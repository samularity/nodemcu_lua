
--ws2812.newBuffer(numberOfLeds, bytesPerLed)
--Green,Red,Blue
ws2812.init()

ws2812.newBuffer(25, 3)
buffer:fill(0, 0,100)

buffer:set(4, {0, 100, 100}) -- set the fifth led red for a RGB strip
buffer:set(5, {0, 255, 0}) -- set the fifth led red for a RGB strip
buffer:set(6, {0, 100, 100}) -- set the fifth led red for a RGB strip


buffer:fade(2, ws2812.FADE_IN)
buffer:fade(2, ws2812.FADE_OUT)

--shift forward one led
--ws2812.SHIFT_LOGICAL or  ws2812.SHIFT_CIRCULAR
-- 3 = ignore first 3 leds
buffer:shift(1 , ws2812.SHIFT_CIRCULAR, 3)

ws2812.write(buffer)
