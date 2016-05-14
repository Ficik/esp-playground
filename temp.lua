

tmr.alarm(4, 5000, 1, function()
    status, temp, humi, temp_dec, humi_dec = dht.read(DHT_PIN)
    if status == dht.OK then
        MyMQTT.send(MQTT_PREFIX.."/temperature", string.format("%d.%01d", math.floor(temp), math.floor(temp_dec/100)))
        MyMQTT.send(MQTT_PREFIX.."/humidity", string.format("%d.%01d", math.floor(humi), math.floor(humi_dec/100)))
    elseif status == dht.ERROR_CHECKSUM then
        print( "DHT Checksum error." )
    elseif status == dht.ERROR_TIMEOUT then
        print( "DHT timed out." )
    end
end)