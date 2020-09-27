import ssl
import sys
import os
import re
import paho.mqtt.client as mqtt
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

capath = r'DST_Root_CA_X3.pem' #certificado root ssl
json_file = r'avicultura-lora-firebase-adminsdk-w9yh3-a0e6634d82.json' #private key
#credenciales de firebase
cred = credentials.Certificate(json_file)
firebase_admin.initialize_app(cred)
db = firestore.client()

def on_connect(client,userdata,flags, rc):
        print('connected(%s)' % client._client_id)
        client.subscribe("nodos/+/medidas")

def on_message(client,userdata,message):
      payload=message.payload.decode().split(',') #obtner payload
      provincia=message.topic
      provincia = re.findall("/([a-zA-Z]+)/",provincia) #obtener provincia
      print(provincia[0])
      print(payload)
      #crear referencia a collection
      doc_ref = db.collection(u'nodos').document(str(provincia[0])) #referencia a la coleccion
      #subir data a base de datos
      doc_ref.set({
          u'fecha_hora': payload[0],
          u'ubicacion': [payload[8],payload[9]], #futuro
          u'nombre_corral': payload[7],
          u'medidas': [float(payload[1]),float(payload[2]),float(payload[3]),float(payload[4]),float(payload[5]),float(payload[6])]
      })

def main():
       client = mqtt.Client(client_id='Recuperacion',clean_session=False)
       client.username_pw_set(username="pi",password="raspberry")
       client.tls_set(capath,tls_version=ssl.PROTOCOL_TLSv1_2)
       client.on_connect=on_connect
       client.on_message=on_message
       client.connect(host='jiclora.duckdns.org',port=8883)
       client.loop_forever()

if __name__=="__main__":
    main()

sys.exit(0)