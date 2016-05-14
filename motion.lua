Motion = {
  sensors = {}
}

function Motion.start()
  tmr.alarm(3, 128, 1, function()
    table.foreach(Motion.sensors, function(index, sensor)
      sensor.read()
    end)
  end)
end

function Motion.new(pin, mqtt_endpoint)

  motion = {
    pin = pin,
    mqtt_endpoint = mqtt_endpoint,
    last_state = 0,
    calibration = 10
  }

  function motion.read()
    if motion.calibration ~= 0 then
        if motion.calibration == 1 then
            gpio.write(motion.pin, gpio.LOW)          
            gpio.mode(motion.pin, gpio.INPUT)
        end
        motion.calibration = motion.calibration - 1
        return 0
    end
    value = gpio.read(motion.pin)
    if motion.last_state ~= value then
      motion.last_state = value
      motion.report(value)
    end
    return value
  end

  function motion.report(value)
    if value == 1 then
        MyMQTT.send(motion.mqtt_endpoint, "MOVEMENT")
    else
        MyMQTT.send(motion.mqtt_endpoint, "CALM")
    end
  end

  gpio.mode(motion.pin, gpio.OUTPUT)
  gpio.write(motion.pin, gpio.HIGH)
  table.insert(Motion.sensors, motion)
  print("new pin initialized")
end

Motion.new(5, '/living-room/motion')
Motion.start()
