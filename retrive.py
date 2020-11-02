#!/usr/bin/python3
import ssl
import sys
import os
import re
import json
import paho.mqtt.client as mqtt
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from google.cloud import firestore as geo
check = None 
capath = r'/etc/ssl/certs/DST_Root_CA_X3.pem' #certificado root ssl
json_file = r'/home/pi/gkey/avicultura-lora.json' #private key
#credenciales de firebase
cred = credentials.Certificate(json_file)
firebase_admin.initialize_app(cred)
db = firestore.client()

def on_connect(client,userdata,flags, rc):
       # print('connected(%s)' % client._client_id)
        client.subscribe("nodos/+/medidas")

def on_message(client,userdata,message):
      global check
      check = True
      try:
         payload=message.payload.decode()
         data = json.loads(payload)
      except:
        check = False
        pass

      provincia=message.topic
      provincia = re.findall("/([a-zA-Z]+)/",provincia) #obtener provincia
     # print(provincia[0])
      doc_ref = db.collection(u'nodos').document(str(provincia[0])) #referencia a la coleccion
      doc = doc_ref.get() #chequear si existe el documento.
      
      if (doc.exists):
        
        if(check==True):
          if ('medidas' in data) : #chequear si es valores de sensore o valores referentes a la salud del sistema
            coords = geo.GeoPoint(float(data['ubicacion']['lat']),float(data['ubicacion']['long']))
            doc_ref.update({
            u'fecha_hora': data['hora'],
            u'ubicacion': coords, #futuro
            u'nombre_corral': data['Corral'],
            u'medidas':[
            round(data['medidas']['agua'],2),
            round(data['medidas']['comida'],2),
            round(data['medidas']['temperatura'],2),
            round(data['medidas']['humedad'],2),
            round(data['medidas']['presion'],2),
            round(data['medidas']['gas'],2)
            ],
            u'promedio':[
            round(data['avgmedidas']['agua'],2),
            round(data['avgmedidas']['comida'],2),
            round(data['avgmedidas']['temperatura'],2),
            round(data['avgmedidas']['humedad'],2),
            round(data['avgmedidas']['presion'],1),
            round(data['avgmedidas']['gas'],2)
            ] 
            })
              
      elif(check==True):
        if ('medidas'in data) :
          coords = geo.GeoPoint(float(data['ubicacion']['lat']),float(data['ubicacion']['long']))
          doc_ref.set({
            u'fecha_hora': data['hora'],
            u'ubicacion': coords, #futuro
            u'nombre_corral': data['Corral'],
            u'medidas':[
            round(data['medidas']['agua'],2),
            round(data['medidas']['comida'],2),
            round(data['medidas']['temperatura'],2),
            round(data['medidas']['humedad'],2),
            round(data['medidas']['presion'],2),
            round(data['medidas']['gas'],2)
            ],
            u'promedio':[
            round(data['avgmedidas']['agua'],2),
            round(data['avgmedidas']['comida'],2),
            round(data['avgmedidas']['temperatura'],2),
            round(data['avgmedidas']['humedad'],2),
            round(data['avgmedidas']['presion'],1),
            round(data['avgmedidas']['gas'],2)
            ]  
            })  
      
          

def main():
       client = mqtt.Client(client_id='Recuperacion',clean_session=False)
       client.username_pw_set(username="pi",password="raspberry")
       client.tls_set(capath,tls_version=ssl.PROTOCOL_TLSv1_2)
       client.on_connect=on_connect
       client.on_message=on_message
       client.connect(host='jiclora.duckdns.org',port=3883)
       client.loop_forever()

#if __name__=="__main__":
main()
#    print('codigo ejecutado correctamente')

sys.exit(0)
