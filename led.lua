LedStrip = {
  LED_MODE_AUTO = 0,
  LED_MODE_MANUAL = 1,
  LED_MODE_DIRECT = 2,
  mode = 0,
}
LedStrip.assignment = Led.assign_pins(pwm, 1, 3, 2, 4)
LedStrip.target_color = Color.create(0, 0, 0, 0)
LedStrip.movement_color = Color.create(0, 0, 0, 0)
LedStrip.SPEED = {
  red_up = 5,
  red_down = 4,
  green_up = 2,
  green_down = 3,
  blue_up = 2,
  blue_down = 5,
  alpha_up = 2,
  alpha_down = 2
}

MyMQTT.subscribe(MQTT_PREFIX.."/kitchen-ambi/mode", function(topic, payload)
  if payload == "AUTO" then
    LedStrip.mode = LedStrip.LED_MODE_AUTO
  elseif payload == "DIRECT" then
    LedStrip.mode = LedStrip.LED_MODE_DIRECT
  elseif payload == "MANUAL" then
    LedStrip.mode = LedStrip.LED_MODE_MANUAL
  end
end)

MyMQTT.subscribe(MQTT_PREFIX.."/kitchen-ambi/color", function(topic, payload)
    LedStrip.target_color.set(Color.from_hex(payload))
    LedStrip.mode = LedStrip.LED_MODE_MANUAL
end)

MyMQTT.subscribe(PREFIX.."/kitchen-ambi/white", function(topic, payload)
    LedStrip.target_color.set(Color.create(0, 0, 0, tonumber(payload)))
    LedStrip.mode = LedStrip.LED_MODE_MANUAL
end)

MyMQTT.subscribe(MQTT_PREFIX.."/motion", function(topic, payload)
    if LedStrip.mode == LedStrip.LED_MODE_AUTO then
        if payload == "MOVEMENT" then
            LedStrip.movement_color.set(Color.create(0, 0, 0, 255))
        elseif payload == "CALM" then
            LedStrip.movement_color.set(Color.create(0, 0, 0, 0))
        end
    end
end)

-- Movement towards target color instead of direct switching
tmr.alarm(2, 150, tmr.ALARM_AUTO, function()
  if LedStrip.mode == LedStrip.LED_MODE_DIRECT then
    LedStrip.assignment.set_color(LedStrip.target_color)
  elseif LedStrip.mode == LedStrip.LED_MODE_AUTO then
    LedStrip.assignment.set_color(LedStrip.assignment.color.move(LedStrip.movement_color, LedStrip.SPEED))
  else
    LedStrip.assignment.set_color(LedStrip.assignment.color.move(LedStrip.target_color, LedStrip.SPEED))
  end
end)
