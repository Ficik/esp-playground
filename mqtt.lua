-- Send hello to MQTT

mqtt_connected = 0

m = mqtt.Client("ESP8266-"..node.chipid(), 60)
m:connect(MQTT_IP, 1883, 0, 1, function(client) print("mqtt connected") end,
                                 function(client, reason) print("failed reason: "..reason) end)

m:on("connect", function(client) 
  mqtt_connected = 1
  print("MQTT Connected")
  m:subscribe("/living-room/kitchen/color", 0, function(client) print("Subscribed to led") end)
  m:subscribe("/living-room/kitchen/mode", 0, function(client) print("Subscribed to led") end)
end)

m:on("message", function(client, topic, data)
  if topic == "/living-room/kitchen/color" then
    print(topic .. ": " .. data)
    if data == "auto" then
      set_led_mode(LED_MODE_AUTO)
    else
      set_led_mode(LED_MODE_COLOR)
      set_target_hex_color(data)
    end
  elseif topic == "/living-room/kitchen/mode" then
    if data == "auto" then
      set_led_mode(LED_MODE_AUTO)
    end
  end
end)


function send_mqtt_message(topic, payload)
  if mqtt_connected then
    print("MQTT Message: "..topic..": "..payload)
    m:publish(topic, payload, 0, 0)
  end
end
