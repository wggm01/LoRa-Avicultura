//Librerias
#include "heltec.h"
#include "WiFi.h"
#include <WiFiClientSecure.h>
#include "time.h"
#include <MQTTClient.h>
#include "secrets.h"
#include <ArduinoJson.h>
//Librerias

//Documento Json
StaticJsonDocument<410> payload;
//Documento Json

//MQTT CONF
WiFiClientSecure net = WiFiClientSecure();
MQTTClient mqttClient = MQTTClient(410);
int rst_flag =20 ;
boolean LOST_BROKER = false;
//MQTT CONF

//Informacion necesaria para el  receptor/demodulador
#define SF 7
#define BAND    915E6  //you can set band here directly,e.g. 868E6,915E6
#define BW 125E3 //[4]Ancho de banda de 125Khz
#define CR 5 //[5]Razon de codificacion. valor por defecto 4/5
#define PL 8 //[6]Preamble Length valor por defecto 8
#define SW 0x34 //[7]Sync Word. valor por defecto 0x43
//Informacion necesaria para el  receptor/demodulador
String packet,snr,rssi ;
String packSize = "--";

//mqtt handlers
void messageHandler(String &topic, String &payload) {
  Serial.println("incoming: " + topic + " - " + payload);

//  StaticJsonDocument<200> doc;
//  deserializeJson(doc, payload);
//  const char* message = doc["message"];
}
//mqtt handlers

void cbk(int packetSize) {
  packet ="";
  packSize = String(packetSize,DEC);
  //Serial.print("Tamaño del paquete");
  //Serial.println(packSize);
  for (int i = 0; i < packetSize; i++) { packet += (char) LoRa.read();}
  //Serial.print("Byte decodificado:");Serial.println(packet);}
  //Figuras de Merito
  snr="SNR:"+String(LoRa.packetSnr(),DEC);
  rssi="RSSI:"+String(LoRa.packetRssi(),DEC);
 // LoRaData();
  
  //Envio de data al broker
  deserializeJson(payload, packet);
  payload["Corral"]="Corral Wvaldo";
  String timedate = printLocalTime();
  timedate.replace("\n", "");
  payload["hora"]=timedate;
  //serializeJsonPretty(payload,Serial);
  char packet[410];
  serializeJson(payload, packet);
  if(mqttClient.publish(MQTT_PUB_TOPIC,packet)){
    Serial.println("paquete enviado");
    }else{
      LOST_BROKER = true;
      }
  //Envio de data al broker
}

//obterner la hora
String printLocalTime()
{
  char buff[80];
  struct tm timeinfo;
  if(!getLocalTime(&timeinfo)){
    Serial.println("Failed to obtain time");
  }
  strftime(buff,80,"%D %T",&timeinfo);
  //Serial.print(buff);
  return buff;

}
//obtener la hora

void connect_jiclora(){
  //MQTT INCIALIZACIONES 
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  Serial.println("Connecting to Wi-Fi");
  digitalWrite(LED,HIGH);

  while (WiFi.status() != WL_CONNECTED){
    delay(500);
    rst_flag -=1;
    //Serial.print("Contador antes de aplicar rst de software: ");
   // Serial.println(rst_flag);
    if(rst_flag ==0){
      //Serial.println("Reseteando ESP32");
      ESP.restart();
      }
    //Serial.print(".");
  }
  Serial.println("WIFI Connected");

  net.setCACert(lets_encrypt_Ca);
  //net.setCertificate(lets_encrypt_CRT);
  //net.setPrivateKey(lets_encrypt_PRIVATE);
  
  mqttClient.begin(MQTT_HOST, MQTT_PORT, net);
  mqttClient.onMessage(messageHandler);

  Serial.println("CONECTANDO A JICLORA BROKER");

  while (!mqttClient.connect(HOSTNAME,MQTT_USER,MQTT_PASS)) {
    Serial.print(".");
    delay(100);
  }

   if(!mqttClient.connected()){
    Serial.println("JICLORA BROKER TIEMPO DE ESPERA EXCEDIDO!");
    return;
  }

  mqttClient.subscribe(MQTT_SUB_TOPIC);

  Serial.println("CONECTADO A JICLORA BROKER!");
  digitalWrite(LED,LOW);
  
  //MQTT INCIALIZACIONES 
  }

  void set_snmp(){
  Serial.print("Setting time using SNTP: ");
  configTime(-5 * 3600, 0, "pool.ntp.org");
  Serial.println(printLocalTime());
    }

void setup() { 
  pinMode(LED,OUTPUT);
  Heltec.begin(true /*DisplayEnable Enable*/, true /*Heltec.Heltec.Heltec.LoRa Disable*/, true /*Serial Enable*/, true /*PABOOST Enable*/, BAND /*long BAND*/);
  LoRa.setSpreadingFactor(SF);
  Heltec.display->init();
  Heltec.display->flipScreenVertically();  
  Heltec.display->setFont(ArialMT_Plain_10);
  //LoRa.onReceive(cbk);
  LoRa.receive();
  connect_jiclora();
  set_snmp();
  }

void loop() {
  if (WiFi.status()== WL_DISCONNECTED || LOST_BROKER == true ){
    connect_jiclora(); //reconecta 
    set_snmp();// configura el la hora nuevamente
    LOST_BROKER = false;
  }else{  
  //Recepcion de data
  int packetSize = LoRa.parsePacket();
  if (packetSize){
    cbk(packetSize);
    //delay(10);  
    }
   //Recepcion de data
   mqttClient.loop(); 
  }
  }
