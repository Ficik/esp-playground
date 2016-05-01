PREFIX = "/living-room/kitchen"

LedStrip = {
  LED_MODE_AUTO = 0,
  LED_MODE_MANUAL = 1,
  mode = 0,
}
LedStrip.assignment = Led.assign_pins(pwm, 1, 2, 3, 4)
LedStrip.target_color = Color.create(0, 0, 0, 0)
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

MyMQTT.subscribe(PREFIX.."/mode", function(topic, payload)
  if payload == "AUTO" then
    LedStrip.mode = LedStrip.LED_MODE_AUTO
    LedStrip.target_color.set(Color.create(0, 0, 0, 0))
  elseif payload == "MANUAL" then
    LedStrip.mode = LedStrip.LED_MODE_MANUAL
  end
end)

MyMQTT.subscribe(PREFIX.."/color", function(topic, payload)
    LedStrip.target_color.set(Color.from_hex(payload))
    LedStrip.mode = LedStrip.LED_MODE_MANUAL
end)

MyMQTT.subscribe(PREFIX.."/white", function(topic, payload)
    LedStrip.target_color.set(Color.create(0, 0, 0, tonumber(payload)))
    LedStrip.mode = LedStrip.LED_MODE_MANUAL
end)

MyMQTT.subscribe(PREFIX.."/motion", function(topic, payload)
    if LedStrip.mode == LedStrip.LED_MODE_AUTO then
        if payload == "1" then
            LedStrip.target_color.set(Color.create(255, 127, 15, 255))
        else
            LedStrip.target_color.set(Color.create(0, 0, 0, 0))
        end
    end
end)

-- Movement towards target color instead of direct switching
tmr.alarm(2, 100, tmr.ALARM_AUTO, function()
  --print(LedStrip.assignment.color.string())
  LedStrip.assignment.set_color(LedStrip.assignment.color.move(LedStrip.target_color, LedStrip.SPEED))
  --LedStrip.assignment.set_color(LedStrip.target_color)
end)
