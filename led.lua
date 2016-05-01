
RED_PIN   = 1
GREEN_PIN = 2
BLUE_PIN  = 3
WHITE_PIN = 4

white_value = -1
red_value = -1
blue_value = -1
green_value = -1

white_target = 0
red_target = 0
blue_target = 0
green_target = 0

LED_MODE_AUTO = 0
LED_MODE_COLOR = 1

led_mode = LED_MODE_AUTO

function start_led(pin)
    pwm.setup(pin, 250, 256)
    pwm.start(pin)
end

function set_led_mode(mode)
  led_mode = mode
end

function set_color(red, green, blue, white)
  if red_value ~= red then
    red_value = red
    pwm.setduty(RED_PIN, pwm_value(red_value) * 2)
  end
  if green_value ~= green then
    green_value = green
    pwm.setduty(GREEN_PIN, pwm_value(green_value) * 2)
  end

  if blue_value ~= blue then
    blue_value = blue
    pwm.setduty(BLUE_PIN, pwm_value(blue_value) * 2)
  end

  if white_value ~= white then
    white_value = white
    pwm.setduty(WHITE_PIN, pwm_value(white_value) * 2)
  end
end

function parse_hex_color(hex)
  hex = hex:gsub("#","")
  if hex:len() == 8 then
      return tonumber("0x"..hex:sub(1,2)), 
             tonumber("0x"..hex:sub(3,4)),
             tonumber("0x"..hex:sub(5,6)),
             tonumber("0x"..hex:sub(7,8))
  elseif hex:len() == 6 then
      return tonumber("0x"..hex:sub(1,2)), 
             tonumber("0x"..hex:sub(3,4)),
             tonumber("0x"..hex:sub(5,6)),
             (tonumber("0x"..hex:sub(1,2)) + tonumber("0x"..hex:sub(3,4)) + tonumber("0x"..hex:sub(5,6))) / 3
  else
    return 0, 0, 0, 0
  end
end

function get_hex_color(hex)
  r, g, b, w = parse_hex_color(hex)
  print("Setting color: "..r..", "..g..", "..b..", "..w)
  return r, g, b, w
end

function set_hex_color(hex)
  set_color(get_hex_color(hex))
end

function set_target_hex_color(hex)
  set_target_color(get_hex_color(hex))
end

function set_target_color(red, green, blue, white)
  red_target = red
  green_target = green
  blue_target = blue
  white_target = white
end

function move_to_target(value, target, max_inc, max_dec)
  if value < target then
    return value + min(max_inc, target - value) 
  elseif value > target then
    return value - min(max_dec, value - target)
  end
  return value
end


-- Movement towards target color instead of direct switching
tmr.alarm(2, 100, tmr.ALARM_AUTO, function()
  set_color(
    move_to_target(red_value, red_target, 5, 4),
    move_to_target(green_value, green_target, 2, 3),
    move_to_target(blue_value, blue_target, 2, 5),
    move_to_target(white_value, white_target, 2, 2)
  )
end)


start_led(GREEN_PIN)
start_led(BLUE_PIN)
start_led(RED_PIN)
start_led(WHITE_PIN)
set_color(0, 0, 0, 0)
