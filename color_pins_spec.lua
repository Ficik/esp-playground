pwm = {
  setup = function(pin, clock, duty) print(pin, clock, duty) end,
  start = function(pin) print(pin) end,
  setduty = function(pin, duty) print(pin, duty) end
}

describe('Led', function()

  setup(function()
    dofile('color_pins.lua')
    dofile('colors.lua')
  end)

  it('should create new Led.pin', function()
    local m_pwm = mock(pwm, true)
    Led.create_pin(m_pwm, 5);
    assert.stub(m_pwm.setup).was.called_with(5, 200, 0)
    assert.stub(m_pwm.start).was.called_with(5)
    mock.revert(m_pwm)
  end)

  it('should not create invalid pin', function()
    pin = Led.create_pin(pwm, nil)
    assert.are.same(pin, nil)

    pin = Led.create_pin(pwm, 0)
    assert.are.same(pin, nil)
  end)

  it('should assign pins', function()
    local m_pwm = mock(pwm, true)
    local assignment = Led.assign_pins(m_pwm, 1, 2, 3, 4)
    assert.stub(m_pwm.setup).was.called_with(4, 200, 0)
    assert.stub(m_pwm.start).was.called_with(4)

    local color = Color.from_hex('#FFFFFF')
    assignment.set_color(color)
    assert.stub(m_pwm.setduty).was.called_with(1, 1020)
    assert.are.same(assignment.color, color)
    assert.are.same(assignment.red.value, color.r)

    mock.revert(m_pwm)
  end)

end)
