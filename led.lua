dofile('color_pins.lua')

PREFIX = "/living-room/kitchen"

LedStrip = {
  LED_MODE_AUTO = 0,
  LED_MODE_MANUAL = 1,
  mode = LED_MODE_AUTO,
}
LedStrip.assignment = Led.assign_pins(1, 2, 3, 4)
LedStrip.target_color = Color.create(0, 0, 0, 0)
LedStrip.SPEED = {
  red_up = 5,
  green_up = 2,
  blue_up = 2,
  alpha_up = 2,
  red_down = 4,
  green_down = 3,
  blue_down = 5,
  alpha_down = 2
}

MyMQTT.subscribe(PREFIX.."/mode", function(topic, payload)
  if payload == "AUTO" then
    LedStrip.mode = LED_MODE_AUTO
  elseif payload == "MANUAL" then
    LedStrip.mode = LED_MODE_MANUAL
  end
end)

MyMQTT.subscribe(PREFIX.."/color", function(topic, payload)
    LedStrip.target_color.set(Color.from_hex(payload))
end)

MyMQTT.subscribe(PREFIX.."/white", function(topic, payload)
    LedStrip.target_color.set(Color.create(0, 0, 0, tonumber(payload)))
end)

-- Movement towards target color instead of direct switching
tmr.alarm(2, 100, tmr.ALARM_AUTO, function()
  led_strip.set_color(led_strip.color.move(target, SPEED))
end)
