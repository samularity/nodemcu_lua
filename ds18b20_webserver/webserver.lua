require('ds18b20')

port = 80
ds18b20.setup(1)
srv=net.createServer(net.TCP)
srv:listen(port,
     function(conn)
          conn:send("HTTP/1.1 200 OK\nContent-Type: text/html\nRefresh: 5\n\n" ..
              "<!DOCTYPE HTML>" ..
              "<html><body>" ..
              "<b>ESP8266 Webserver</b></br>" ..
              "Temperature : " .. ds18b20.read() .. " &ordm;C<br>" .. -- &ordm; -> html ° Zeichen
              "Node ChipID : " .. node.chipid() .. "<br>" ..
              "Node MAC : " .. wifi.sta.getmac() .. "<br>" ..
              "Node Heap : " .. node.heap() .. "<br>" ..
              "Timer Ticks : " .. tmr.now() .. "<br>" ..
              "Voltage : " .. adc.readvdd33() .. "mV<br>" ..
              "</html></body>")          
          conn:on("sent",function(conn) conn:close() end)
     end
)