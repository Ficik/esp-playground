 --Start everything
dofile("config.lua")

print("initializing led")
dofile("utils.lua")
dofile("led.lua")

print("Connecting to wifi")
-- Connect to Wifi
wifi.setmode(wifi.STATION)
wifi.sta.config(WIFI_ESSID, WIFI_PASSWORD)
wifi.sta.connect()
tmr.alarm(1, 1000, 1, function()
  if wifi.sta.getip() == nil then
    print("IP unavaiable, Waiting...")
  else
    tmr.stop(1)
    print("Connected: "..wifi.sta.getip())
    print("Connecting to MQTT")
    dofile("mqtt.lua")
    dofile("motion.lua")
  end
end)
