MyMQTT = {
  connected = 0,
  subscribers = {},
  client = mqtt.Client("ESP8266-"..node.chipid(), 60)
}

function MyMQTT.connect(ip, port)
  print("Connecting to mqtt at "..ip..":"..port)
  MyMQTT.client:connect(ip, port, 0, 1,
  function(client)
    print("MyMQTT connected (connect)")
    MyMQTT.connected = 1
    table.foreach(MyMQTT.subscribers, function(index, subscriber)
        print("MQTT sub "..subscriber.topic)
        MyMQTT.client:subscribe(subscriber.topic, 0, print("Subscribed to"..subscriber.topic))
    end)
  end,
  function(client, reason)
    print("MyMQTT connection failed: "..reason)
  end)
end

function MyMQTT.subscribe(topic, callback)
  print("Addint topic to subscribtion "..topic)
  table.insert(MyMQTT.subscribers, {
    topic = topic,
    callback = callback
  })
  if MyMQTT.connected == 1 then
    MyMQTT.client:subscribe(topic, 0, print("Subscribed to"..topic))
  end
end

function MyMQTT.send(topic, payload)
  if MyMQTT.connected == 1 then
    print("MQTT Message: "..topic..": "..payload)
    m:publish(topic, payload, 0, 0)
  end
end

MyMQTT.client:on("message", function(client, topic, data)
  print("MyMQTT received "..topic..": "..data)
  table.foreach(MyMQTT.subscribers, function(index, subscriber)
    if subscriber.topic == topic then
      subscriber.callback(subscriber.topic, data)
    end
  end)
end)


wifi.sta.eventMonReg(wifi.STA_GOTIP, function()
  MyMQTT.connect(MQTT_IP, MQTT_PORT)
end)

if wifi.sta.status() == wifi.STA_GOTIP then
    MyMQTT.connect(MQTT_IP, MQTT_PORT)
end
