ap_cfg=
 {
  ssid="Temperatur",
  pwd="12345678"
 }
ip_cfg =
  {
   ip="192.168.0.1",
   netmask="255.255.255.0",
   gateway="192.168.0.1"
  }
wifi.setmode(wifi.SOFTAP)
wifi.ap.config(ap_cfg)
wifi.ap.setip(ip_cfg)