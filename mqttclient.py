import paho.mqtt.client as mqtt
import ssl
import os
broker_addr = "jiclora.duckdns.org"
port = 8883
capath = r'/etc/ssl/certs/DST_Root_CA_X3.pem'
#capath = r'C:\Users\wggm\OneDrive\Contribuciones\JIC2020\certs'
client = mqtt.Client("legiony7")
client.username_pw_set(username="pi",password="raspberry")
client.tls_set(capath,tls_version=ssl.PROTOCOL_TLSv1_2)

client.connect(broker_addr,port)
for i in range(10):
    client.subscribe("world")
    client.publish("world","SSL FUNCIONANDO")
client.disconnect()
