Color = {}

function Color.create(r, g, b, a)
  local color = {
    r = r,
    g = g,
    b = b,
    a = a,
  }

  function color.set(new_color)
    if new_color.r ~= nil then
      color.r = new_color.r
    end
    if new_color.g ~= nil then
      color.g = new_color.g
    end
    if new_color.b ~= nil then
      color.b = new_color.b
    end
    if new_color.a ~= nil then
      color.a = new_color.a
    end
    return color
  end

  function move(from, to, speed_up, speed_down)
    if from == nil then
      from = to
    end
    if to == nil then
      return from
    end
    if to > from then
      return from + speed_up
    elseif to < from then
      return from - speed_down
    else
      return from
    end
  end

  function color.move(new_color, step)
    if new_color ~= nil then
      color.set(Color.create(
        move(new_color.r, color.r, step.red_up, step.red_down),
        move(new_color.g, color.g, step.green_up, step.green_down),
        move(new_color.b, color.b, step.blue_up, step.blue_down),
        move(new_color.a, color.a, step.alpha_up, step.alpha_down)
      ))
    end
    return color
  end

  function color.string()
    return color.r..", "..color.g..", "..color.b..", "..color.a
  end

  return color
end

function Color.parse_hex(hex)
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
             nil
  else
    return nil, nil, nil, nil
  end
end

function Color.from_hex(hex)
  return Color.create(Color.parse_hex(hex))
end
