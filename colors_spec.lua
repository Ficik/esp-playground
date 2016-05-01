describe('Colors', function()

  setup(function()
    dofile('colors.lua')
  end)

  it('should create new Color', function()
    c = Color.create(255, 128, 0, 1)
    assert.are.same({c.r, c.g, c.b, c.a}, {255, 128, 0, 1})
  end)

  it('should parse hex RGB color', function()
    local r, g, b = Color.parse_hex('#FFFFFF')
    assert.are.same({255, 255, 255}, {r, g, b})

    r, g, b = Color.parse_hex('#FF0000')
    assert.are.same({255, 00, 00}, {r, g, b})

    r, g, b = Color.parse_hex('#00FF00')
    assert.are.same({00, 255, 00}, {r, g, b})

    r, g, b = Color.parse_hex('#0000FF')
    assert.are.same({00, 00, 255}, {r, g, b})
  end)

  it('should create color from hex', function()
    local c = Color.from_hex("#FFFFFF")
    assert.are.equals(c.r, 255)
    assert.are.equals(c.g, 255)
    assert.are.equals(c.b, 255)
    assert.are.equals(c.a, nil)
  end)

  it('should set colors', function()
    local c = Color.from_hex("#FFFFFF")
    local w = Color.create(nil, nil, nil, 255)
    assert.are.equals(c.a, nil)
    local mixed = c.set(w)
    assert.are.equals(mixed.r, 255)
    assert.are.equals(mixed.a, 255)
  end)

  it('should move to color', function()
    local c = Color.from_hex("#FFFFFF")
    local dest = Color.create(0, 0, 0)
    c.move(dest, {
      red_up = 1,
      green_up = 2,
      blue_up = 3,
      alpha_up = 5,
      red_down = 1,
      green_down = 2,
      blue_down = 3,
      alpha_down = 5
    })
  end)

end)
