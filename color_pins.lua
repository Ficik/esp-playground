Led = {}

function Led.create_pin(pwm, pin)
  if pin == nil or not(pin >= 1 and pin <= 12) then
    return nil
  end

  local Pin = {
    pin = pin,
    value = 0
  }

  pwm.setup(Pin.pin, 400, Pin.value)
  pwm.start(Pin.pin)

  function Pin.set_value(value)
    if value ~= nil and Pin.value ~= value then
      Pin.value = value
      if value > 0 then
        value = ((value + 1) * 4) - 1
      end
      pwm.setduty(Pin.pin, value)
    end
  end

  return Pin
end

function Led.assign_pins(pwm, red_pin, blue_pin, green_pin, white_pin)

  local pins = {
    color = Color.create(0, 0, 0, 0),
    red = Led.create_pin(pwm, red_pin),
    green = Led.create_pin(pwm, green_pin),
    blue = Led.create_pin(pwm, blue_pin),
    white = Led.create_pin(pwm, white_pin)
  }

  function pins.set_color(color)
    pins.color = color
    pins.red.set_value(color.r)
    pins.green.set_value(color.g)
    pins.blue.set_value(color.b)
    pins.white.set_value(color.a)
  end

  return pins
end
