MOTION_PIN = 5

gpio.mode(MOTION_PIN, gpio.OUTPUT)
gpio.mode(MOTION_PIN, gpio.HIGH)

last_state = 0

tmr.alarm(3, 1000, 1, function()
    tmr.stop(3)
    gpio.mode(MOTION_PIN, gpio.LOW)
    gpio.mode(MOTION_PIN, gpio.INPUT)
    tmr.alarm(3, 100, 1, function()
        value = gpio.read(MOTION_PIN)
        if last_state ~= value then
            send_mqtt_message("/living-room/motion", value)
            last_state = value
        end
        if led_mode == LED_MODE_AUTO then
          if value == 1 then
            set_target_color(255, 140, 17, 255)
          else
            set_target_color(0, 0, 0, 0)
          end
        end
    end)
end)


