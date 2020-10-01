//Librerias
#include "heltec.h" //Esta Libreria llama a la de Lora.h
#include <Wire.h>
#include <SPI.h>
#include <Adafruit_Sensor.h>
#include "Adafruit_BME680.h"
//Librerias

//GPS UBICACION
double latitude = 9.045448;
double longitude = -79.406670;
//GPS UBICACION

//NOMBRE DEL CORRAL
String nombre_corral = "Casa D40";
//NOMBRE DEL CORRAL

//programador de obtencion de data
const long interval = 5000;
unsigned long prev;
//programador de obtencion de data
//BME680
Adafruit_BME680 bme; // I2C
//BME680
//Sensor HCSR04
#define TRIG2 32
#define ECHO2 37
#define TRIG1 33
#define ECHO1 39
#define TRIG_US 50
volatile int echo_start1 = 0;
volatile int echo_start2 = 0;
volatile int echo_end1 = 0;
volatile int echo_end2 = 0;
volatile int echo_duration1 = 0;
volatile int echo_duration2 = 0;
//Sensor HCSR04

//variables para timer
volatile int TICK_COUNTS = 4000;
static int TICK_REF = 4000;
hw_timer_t * timer = NULL;
portMUX_TYPE timerMux = portMUX_INITIALIZER_UNLOCKED;
//variables para timer

//Configuraciones del transmisor
#define txP 14 //[1]Valor por defecto en dB
#define Opin RF_PACONFIG_PASELECT_PABOOST//[1]Pin de salida del modulador LoRa
#define BAND 915E6//[2]BANDA
#define SF 7//[3]SPREADING FACTOR por defecto 7
#define BW 125E3 //[4]Ancho de banda de 125Khz
#define CR 5 //[5]Razon de codificacion. valor por defecto 4/5
#define PL 8 //[6]Preamble Length valor por defecto 8
#define SW 0x34 //[7]Sync Word. valor por defecto 0x43
//[8]CRC se configura directamente con un metodo. por defecto esta desactivado.
//Configuraciones del transmisor
//Variables para visualizacion
String sf,rb,band,bw,rs,power;
float RB,RS,c1,c2; //Variables para visualizacion
//Configuraciones del transmisor
//------------Visualizacion de parametros
void param (){
  c1=4/(4+4/CR);
  c2=pow(2,SF)/BW;
  RB=SF*c1/c2*1E3;
  RS=BW/pow(2,SF);
  sf=String(SF);
  rb=String(RB);
  rs=String(RS);
  band=String(BAND);
  bw=String(BW);
  power=String(txP);
  Heltec.display->clear();
  Heltec.display->drawString(0, 0, "Parametros de Transmisor");
  Heltec.display->drawString(0, 10, "SF:");
  Heltec.display->drawString(20, 10, sf);
  
  Heltec.display->drawString(30, 10, "BW:");
  Heltec.display->drawString(50, 10, bw);
  Heltec.display->drawString(105, 10, "Hz");
  
  Heltec.display->drawString(0, 20, "RB:");
  Heltec.display->drawString(20, 20, rb);
  Heltec.display->drawString(80, 20, "bps");

  Heltec.display->drawString(0, 30, "RS:");
  Heltec.display->drawString(20, 30, rs);
  Heltec.display->drawString(60, 30, "sps");

  Heltec.display->drawString(0, 40, "BANDA:");
  Heltec.display->drawString(40, 40, band);
  Heltec.display->drawString(110, 40, "Hz");
  
  Heltec.display->drawString(0, 50, "PotenciaTx:");
  Heltec.display->drawString(55, 50, power);
  Heltec.display->drawString(65, 50, "dB");
  
  Heltec.display->display();
  delay(4000); //4seg para poder apreciar los parametros
  Heltec.display->clear();
  }
//------------Visualizacion de parametros

//ISR S
void echo1_isr () {
  switch (digitalRead(ECHO1)){
    case HIGH:
      echo_end1 = 0;
      echo_start1 = micros();
      break;
    case LOW:
      echo_end1 = micros();
      echo_duration1 = echo_end1 - echo_start1;
      break;}}

void echo2_isr () {
  switch (digitalRead(ECHO2)){
    case HIGH:
      echo_end2 = 0;
      echo_start2 = micros();
      break;
    case LOW:
      echo_end2 = micros();
      echo_duration2 = echo_end2 - echo_start2;
      break;}}

void IRAM_ATTR shot_pulse(){
  portENTER_CRITICAL_ISR(&timerMux);
  static volatile int state = 0;
  TICK_COUNTS -= 1;
  if(TICK_COUNTS == 0){
    state = 1;
    TICK_COUNTS =TICK_REF;
    }
    switch(state){
      case 0:
        break;
      case 1:
        digitalWrite(TRIG1, HIGH);
        digitalWrite(TRIG2, HIGH);
        state = 2;
        break;
      case 2:
        digitalWrite(TRIG1, LOW);
        digitalWrite(TRIG2, LOW);
        state =0;
        break;
      }
        
  portEXIT_CRITICAL_ISR(&timerMux);
  }
//ISR S

void setup() {
//Configuraciones del transmisor
pinMode(LED,OUTPUT);
Heltec.begin(true /*DisplayEnable Enable*/, true /*Heltec.LoRa Disable*/, true /*Serial Enable*/, true /*PABOOST Enable*/, BAND /*long BAND*/);
//Incializa la libreria, el oled,lora y el puerto serial en 115200baud.
LoRa.setTxPower(txP,Opin);//[1][1]
//LoRa.setFrequency(BAND);//[2]
LoRa.setSpreadingFactor(SF);//[3]
LoRa.setSignalBandwidth(BW);//[4]
LoRa.setCodingRate4(CR);//[5]
LoRa.setPreambleLength(PL);//[6]
LoRa.setSyncWord(SW);//[7]
LoRa.disableCrc();
//Configuraciones del transmisor

//Inicializacion de OLED
Heltec.display->init();
Heltec.display->flipScreenVertically();  
Heltec.display->setFont(ArialMT_Plain_10);
param();
Heltec.display->drawString(0, 0, " ");
Heltec.display->display();
//Inicializacion de OLED

//BME 680 INICIALIZACION
Wire.begin(4,15);
if (!bme.begin()) {
    Serial.println("Could not find a valid BME680 sensor, check wiring!");
    while (1);
  }
// Set up oversampling and filter initialization
bme.setTemperatureOversampling(BME680_OS_8X);
bme.setHumidityOversampling(BME680_OS_2X);
bme.setPressureOversampling(BME680_OS_4X);
bme.setIIRFilterSize(BME680_FILTER_SIZE_3);
bme.setGasHeater(320, 150); // 320*C for 150 ms
//BME 680 INICIALIZACION

//pines para hcs sr04
pinMode(TRIG1,OUTPUT);
pinMode(TRIG2,OUTPUT);
pinMode(ECHO1,INPUT);
pinMode(ECHO2,INPUT);
digitalWrite(TRIG1, LOW);
digitalWrite(TRIG2, LOW);
//pines para hcs sr04

//interrupciones y timer  
attachInterrupt(ECHO1, echo1_isr, CHANGE);
attachInterrupt(ECHO2, echo2_isr, CHANGE);

timer = timerBegin(0, 240, true);
timerAttachInterrupt(timer, &shot_pulse, CHANGE);
timerAlarmWrite(timer, TRIG_US, true);
timerAlarmEnable(timer);
//interrupciones y timer  


}


void loop() {
  unsigned long current =  millis();
  if (current - prev == interval){
    prev = current;
    
    if (! bme.performReading()) {
    Serial.println("Failed to perform reading :(");
    return;
    }
    else{
    String frame = String(latitude,6)+ "," +String(longitude,6)+ "," +nombre_corral+ "," +String(echo_duration1/58) + "," + String(echo_duration2/58)+ "," +String(bme.temperature)+ "," +String(bme.humidity)+ "," +String(bme.pressure / 100)+ "," +String(bme.gas_resistance / 1000.0);
    //Serial.println(frame);
    LoRa.beginPacket();
    LoRa.print(frame);
    LoRa.endPacket();
    }
    }
 
}
