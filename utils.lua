function max(a, b)
  if a > b then
    return a
  end
  return b
end

function abs(x)
  if x < 0 then
    return -1 * x
  end
  return x
end

function min(a, b)
  if a < b then
    return a
  end
  return b
end

function bounded(value, lower, upper)
  return min(max(value, lower), upper)
end

function pwm_value(value)
  value = bounded(value, 0, 255)
  if value == 1 then
    value = 0
  end
  return value
end


function hex2rgb(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end