#include <WiFi.h>
//#include <WiFiClientSecure.h>  //included WiFiClientSecure does not work!
#include "src/dependencies/WiFiClientSecure/WiFiClientSecure.h" //using older WiFiClientSecure
#include <time.h>
#include <PubSubClient.h>
#include "secrets.h"
#include <dhtnew.h> //necesitas instalar la libreria DHTNEW !!!!!!!!!!!!!!!!!!!!!!1
//ACTUALIZAR EL SSID Y CONTRASENA!!!!!!!!!!!!! en secrets.h

//control de envio de datos
unsigned long  previousMillis = 0;
const long interval = 3000; 
//control de envio de datos fin

//SENSOR DE DISTANCIA ANALOGO
const int analog_in = 37;
int dist_volt = 0;
int ir_distd;
//SENSOR DE DISTANCIA ANALOGO fin

//SENSOR LDR
const int ldr_in = 38;
int digital_value = 0;
//SENSOR LDR fin

//INSTANCIA DE SENSOR DHT11
DHTNEW mySensor(36);
int temp = 0;
int hum = 0;
int temp2_disp;
int hum2_disp;
//INSTANCIA DE SENSOR DHT11 fin

//TRAMA PARA ENVIO DE DATOS
String trama;
//TRAMA PARA ENVIO DE DATOS fin

//const char MQTT_SUB_TOPIC[] = "home/" HOSTNAME "/in";
const char MQTT_PUB_TOPIC[] = "Panama/"HOSTNAME"/medidas";

WiFiClientSecure net;
PubSubClient client(net);

time_t now;
unsigned long lastMillis = 0;

void mqtt_connect()
{
    while (!client.connected()) {
    Serial.print("Time:");
    Serial.print(ctime(&now));
    Serial.print("MQTT connecting");
    if (client.connect(HOSTNAME, MQTT_USER, MQTT_PASS)) {
      Serial.println("connected");
      //client.subscribe(MQTT_SUB_TOPIC);
    } else {
      Serial.print("failed, status code =");
      Serial.print(client.state());
      Serial.println("try again in 5 seconds");
      /* Wait 5 seconds before retrying */
      delay(5000);
    }
  }
  
}

/*void receivedCallback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Received [");
  Serial.print(topic);
  Serial.print("]: ");
  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }
}*/


/*-----------toma de lecturas--------------*/
void enviar_pkt (){
  unsigned long currentMillis = millis();
  if (currentMillis - previousMillis >= interval) {
    // save the last measure time:
    previousMillis = currentMillis;
    //valor del sensor LDR
    digital_value = analogRead(ldr_in);
    //valor de voltaje del sensor pololu:
    dist_volt = analogRead(analog_in);
    //conversion:
    int ir_dist = 187754 * pow(dist_volt,-1.51);
    if(ir_dist < 15){
      ir_distd = ir_dist;
      }else {ir_distd = 16;}
    //lectura de temperatura y humedad:
    mySensor.read();
    temp = mySensor.getTemperature();
    hum = mySensor.getHumidity();
    //Preparacion de trama a enviar a mqtt O LORA WAN
    trama = String(ir_distd) + "," + String(temp) + "," + String(hum) + "," + String(digital_value);
    int trama_len = trama.length() + 1;
    char trama_buff[trama_len];
    trama.toCharArray(trama_buff,trama_len);
    bool chk = client.publish(MQTT_PUB_TOPIC,trama_buff,false);
    //if(chk){Serial.println("Paquete enviado");}else{Serial.println("Paquete !enviado");}
  }}

void setup()
{
  Serial.begin(115200);

  Serial.print("Attempting to connect to SSID: ");
  Serial.println(ssid);
  WiFi.setHostname(HOSTNAME);
  WiFi.mode(WIFI_AP_STA);
  WiFi.begin(ssid, pass);
  while (WiFi.status() != WL_CONNECTED)
  {
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
}

void loop()
{
  now = time(nullptr);
  if (WiFi.status() != WL_CONNECTED)
  {
    Serial.print("Checking wifi");
    while (WiFi.waitForConnectResult() != WL_CONNECTED)
    {
      WiFi.begin(ssid, pass);
      Serial.print(".");
      delay(10);
    }
    Serial.println("connected");
  }
  else
  {
    if (!client.connected())
    {
      mqtt_connect();
    }
    else
    {
      client.loop();
    }
  }

  enviar_pkt ();
}
