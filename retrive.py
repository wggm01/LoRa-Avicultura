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
json_file = r'/home/pi/gkey/avicultura.json' #private key
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
      doc_ref = db.collection(u'nodos').document('PanamaDonbosco') #referencia a la coleccion
      print("referencia creada")
      doc = doc_ref.get() #chequear si existe el documento.
      print("obtencion de documento")
      if (doc.exists):
        print("existe")
      #   if(check==True):
      #     if (1==1) : #chequear si es valores de sensore o valores referentes a la salud del sistema
      #       coords = geo.GeoPoint(float(data['ubicacion']['lat']),float(data['ubicacion']['long']))
      #       doc_ref.update({
      #       u'fecha_hora': data['hora'],
      #       u'ubicacion': coords, #futuro
      #       u'nombre_corral': data['Corral'],
      #       u'medidas': [float(data['medidas']['agua']),float(data['medidas']['comida']),float(data['medidas']['temperatura']),float(data['medidas']['humedad']),float(data['medidas']['presion']),float(data['medidas']['gas'])],
      #       u'promedio': [float(data['avgmedidas']['agua']),float(data['avgmedidas']['comida']),float(data['avgmedidas']['temperatura']),float(data['avgmedidas']['humedad']),float(data['avgmedidas']['presion']),float(data['avgmedidas']['gas'])] 
      #       })
              
      elif(check==True):
        print("no existe, creando...")
      #   if (1==1) :
      #     coords = geo.GeoPoint(float(data['ubicacion']['lat']),float(data['ubicacion']['long']))
      #     doc_ref.set({
      #       u'fecha_hora': data['hora'],
      #       u'ubicacion': coords, #futuro
      #       u'nombre_corral': data['Corral'],
      #       u'medidas': [float(data['medidas']['agua']),float(data['medidas']['comida']),float(data['medidas']['temperatura']),float(data['medidas']['humedad']),float(data['medidas']['presion']),float(data['medidas']['gas'])],
      #       u'promedio': [float(data['avgmedidas']['agua']),float(data['avgmedidas']['comida']),float(data['avgmedidas']['temperatura']),float(data['avgmedidas']['humedad']),float(data['avgmedidas']['presion']),float(data['avgmedidas']['gas'])] 
      #       })  
      
          

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
