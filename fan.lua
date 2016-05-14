gpio.mode(FAN_PIN, gpio.OUTPUT)

MyMQTT.subscribe(MQTT_PREFIX.."/fan", function(topic, payload)
    if payload == "ON" then
        gpio.write(FAN_PIN, gpio.HIGH)
    elseif payload == "OFF" then
        gpio.write(FAN_PIN, gpio.LOW)
    end
end)
