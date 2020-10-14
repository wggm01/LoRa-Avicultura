#!/usr/bin/python3
import ssl
import sys
import os
import re
import paho.mqtt.client as mqtt
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from google.cloud import firestore as geo

capath = r'/etc/ssl/certs/DST_Root_CA_X3.pem' #certificado root ssl
json_file = r'/home/pi/googlekeys/avicultura-lora-firebase-adminsdk-w9yh3-a0e6634d82.json' #private key
#credenciales de firebase
cred = credentials.Certificate(json_file)
firebase_admin.initialize_app(cred)
db = firestore.client()

def on_connect(client,userdata,flags, rc):
       # print('connected(%s)' % client._client_id)
        client.subscribe("nodos/+/medidas")

def on_message(client,userdata,message):
      payload=message.payload.decode().split(',') #obtner payload
      paylength=len(payload)
      provincia=message.topic
      provincia = re.findall("/([a-zA-Z]+)/",provincia) #obtener provincia
     # print(provincia[0])
     # print(payload)
       
      doc_ref = db.collection(u'nodos').document(str(provincia[0])) #referencia a la coleccion

      doc = doc_ref.get() #chequear si existe el documento.

      if (doc.exists):

          if (paylength == 10) : #subir data a base de datos
            coords = geo.GeoPoint(float(payload[1]),float(payload[2]))
            doc_ref.update({
                u'fecha_hora': payload[0],
                u'ubicacion': coords, #futuro
                u'nombre_corral': payload[3],
                u'medidas': [float(payload[4]),float(payload[5]),float(payload[6]),float(payload[7]),float(payload[8]),float(payload[9])], 
            })
      
          elif(paylength == 6):
            doc_ref.update({
            u'promedio': [float(payload[0]),float(payload[1]),float(payload[2]),float(payload[3]),float(payload[4]),float(payload[5])]
            }) 
      else:
            coords = geo.GeoPoint(float(payload[1]),float(payload[2]))
            doc_ref.set({
                u'fecha_hora': payload[0],
                u'ubicacion': coords, #futuro
                u'nombre_corral': payload[3],
                u'medidas': [float(payload[4]),float(payload[5]),float(payload[6]),float(payload[7]),float(payload[8]),float(payload[9])], 
                u'promedio': [0,0,0,0,0,0]
            })
      
          

def main():
       client = mqtt.Client(client_id='Recuperacion',clean_session=False)
       client.username_pw_set(username="pi",password="raspberry")
       client.tls_set(capath,tls_version=ssl.PROTOCOL_TLSv1_2)
       client.on_connect=on_connect
       client.on_message=on_message
       client.connect(host='jiclora.duckdns.org',port=8883)
       client.loop_forever()

#if __name__=="__main__":
main()
#    print('codigo ejecutado correctamente')

sys.exit(0)
