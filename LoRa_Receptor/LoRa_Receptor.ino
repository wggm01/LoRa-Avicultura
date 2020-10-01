//Librerias
#include "heltec.h"
#include <WiFi.h>
#include "src/dependencies/WiFiClientSecure/WiFiClientSecure.h"
#include <time.h>
#include <PubSubClient.h>
#include "secrets.h"
//Librerias

//MQTT INFO
const char MQTT_PUB_TOPIC[] = "nodos/"HOSTNAME"/medidas";
//MQTT INFO

//MQTT CONF
WiFiClientSecure net;
PubSubClient client(net);
time_t now;
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

void LoRaData(){
  Heltec.display->clear();
  Heltec.display->setTextAlignment(TEXT_ALIGN_LEFT);
  Heltec.display->setFont(ArialMT_Plain_10);
  Heltec.display->drawString(0 , 0, "Rx:");
  Heltec.display->drawString(15 , 0, packet);
  Heltec.display->drawString(0 , 10, snr);
  Heltec.display->drawString(0 , 20, rssi);  
  Heltec.display->display();
  Heltec.display->clear();
}

void cbk(int packetSize) {
  packet ="";
  packSize = String(packetSize,DEC);
  //Serial.print("Tamaño del paquete");
  //Serial.println(packSize);
  for (int i = 0; i < packetSize; i++) { packet += (char) LoRa.read();}
  //Serial.print("Byte decodificado:");Serial.println(packet);}
  //Figuras de Merito
  Serial.println(packet);
  snr="SNR:"+String(LoRa.packetSnr(),DEC);
  rssi="RSSI:"+String(LoRa.packetRssi(),DEC);
 // LoRaData();
  
  //Envio de data al broker
  String timedate =ctime(&now);
  timedate.replace("\n", "");
  packet = timedate + ","+ packet; 
  int trama_len = packet.length() + 1;
  char trama_buff[trama_len];
  packet.toCharArray(trama_buff,trama_len);
  bool chk = client.publish(MQTT_PUB_TOPIC,trama_buff,false);
  //Envio de data al broker
}

//MQTT FUNCIONES

void mqtt_connect(){
    while (!client.connected()) {
    Serial.print("Time:");
    Serial.print(ctime(&now));
    Serial.print("MQTT connecting");
    if (client.connect(HOSTNAME, MQTT_USER, MQTT_PASS)) {
      digitalWrite(LED,LOW);
      Serial.println("connected");
      //client.subscribe(MQTT_SUB_TOPIC);
    } else {
      Serial.print("failed, status code =");
      Serial.print(client.state());
      Serial.println("try again in 5 seconds");
      /* Wait 5 seconds before retrying */
      delay(5000);}}}

void receivedCallback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Received [");
  Serial.print(topic);
  Serial.print("]: ");
  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }
}

//MQTT FUNCIONES

void setup() { 
  pinMode(LED,OUTPUT);
  Heltec.begin(true /*DisplayEnable Enable*/, true /*Heltec.Heltec.Heltec.LoRa Disable*/, true /*Serial Enable*/, true /*PABOOST Enable*/, BAND /*long BAND*/);
  LoRa.setSpreadingFactor(SF);
  Heltec.display->init();
  Heltec.display->flipScreenVertically();  
  Heltec.display->setFont(ArialMT_Plain_10);
  //LoRa.onReceive(cbk);
  LoRa.receive();
  
  //MQTT INCIALIZACIONES BLA BLA
  Serial.print("Attempting to connect to SSID: ");
  Serial.println(ssid);
  WiFi.setHostname(HOSTNAME);
  WiFi.mode(WIFI_AP_STA);
  WiFi.begin(ssid, pass);
  while (WiFi.status() != WL_CONNECTED)
  {
    digitalWrite(LED,HIGH);
    Serial.print(".");
    delay(1000);
  }
 
  Serial.println();
  Serial.print("Connected to ");
  Serial.println(ssid);

  Serial.print("Setting time using SNTP");
  configTime(-5 * 3600, 0, "pool.ntp.org");
  now = time(nullptr);
  while (now < 1510592825) {
    delay(500);
    Serial.print(".");
    now = time(nullptr);
  }
  Serial.println("");
  struct tm timeinfo;
  gmtime_r(&now, &timeinfo);
  Serial.print("Current time: ");
  Serial.print(asctime(&timeinfo));

  net.setCACert(local_root_ca);
  client.setServer(MQTT_HOST, MQTT_PORT);
  client.setCallback(receivedCallback);
  mqtt_connect();
  //MQTT INCIALIZACIONES BLA BLA
  
  }

void loop() {
  //INICIALIZACION WIFI, MQTT BLA BLA
     now = time(nullptr);
  if (WiFi.status() != WL_CONNECTED){
    Serial.print("Checking wifi");
    while (WiFi.waitForConnectResult() != WL_CONNECTED){
      WiFi.begin(ssid, pass);
      Serial.print(".");
      delay(10);}
    Serial.println("connected");}
  else{
    if (!client.connected()){
      mqtt_connect();}
    else{
      client.loop();
    }}
  //INICIALIZACION WIFI, MQTT BLA BLA
  //Recepcion de data
  int packetSize = LoRa.parsePacket();
  if (packetSize){
    cbk(packetSize);
    //delay(10);  
    }
   //Recepcion de data 
    }
