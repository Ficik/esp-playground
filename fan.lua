FAN_PIN = 6
gpio.mode(FAN_PIN, gpio.OUTPUT)

MyMQTT.subscribe("/living-room/fan", function(topic, payload)
    if payload == "ON" then
        gpio.write(FAN_PIN, gpio.HIGH)
    elseif payload == "OFF" then
        gpio.write(FAN_PIN, gpio.LOW)
    end
end)