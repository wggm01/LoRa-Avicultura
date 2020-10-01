import time
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
json_file = r'avicultura-lora-firebase-adminsdk-w9yh3-a0e6634d82.json'
# Use the application default credentials
cred = credentials.Certificate(json_file)
firebase_admin.initialize_app(cred)
db = firestore.client()
ts = time.gmtime()

#logica para elegir a que coleccion subir la database


doc_ref = db.collection(coleccion).document(documento) #referencia a la coleccion

#set/update

doc_ref.set({
    u'fecha_hora': time.strftime("%x %X", ts),
    u'ubicacion': [9.045612,-79.406609],
    u'nombre_corral': u'Casa D40',
    u'medidas': [24.0,16.0,6.0,34.0,1.5,0.75],
})
