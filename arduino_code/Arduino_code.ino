#include <dht.h>

dht DHT;

#define DHT11_PIN 7
#define FloatSensor 2
#define led 13
#define buttonState 1
#define trigPin 9
#define echoPin 10
#define sensorMin 0
#define sensorMax 1024

float sensorVals[5]={0,0,0,0,0};
int i;
long duration;
int distance;
int rainStatus;

void setup(){
  pinMode(trigPin, OUTPUT); // Sets the trigPin as an Output
  pinMode(echoPin, INPUT); // Sets the echoPin as an Input
  Serial.begin(9600);
  pinMode(FloatSensor, INPUT_PULLUP); //Arduino Internal Resistor 10K
  pinMode (led, OUTPUT);
}

void loop(){
  int chk = DHT.read11(DHT11_PIN);
  
  RainStatus();
  
  WaterLevel();
  
  sensorVals[0] = DHT.temperature;
  sensorVals[1] = DHT.humidity;
  sensorVals[2] = digitalRead(FloatSensor);
  sensorVals[3] = distance;
  sensorVals[4] = rainStatus;
  
  Serial.print(sensorVals[0]);
  Serial.print(",");
  Serial.print(sensorVals[1]);
  Serial.print(",");
  Serial.print(sensorVals[2]);
  Serial.print(",");
  Serial.print(sensorVals[3]);
  Serial.print(",");
  Serial.println(sensorVals[4]);  
  delay(2000);
}

void WaterLevel(){
  // Clears the trigPin
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  // Sets the trigPin on HIGH state for 10 micro seconds
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  // Reads the echoPin, returns the sound wave travel time in microseconds
  duration = pulseIn(echoPin, HIGH);
  // Calculating the distance
  distance= duration*0.034/2;
}

void RainStatus(){
  int sensorReading = analogRead(A0);
  int range = map(sensorReading, sensorMin, sensorMax, 0, 3);

  switch (range)
    {
      case 0:
        rainStatus = 1111;
        break;

      case 1:
        rainStatus = 1010;
        break;

      case 2:
        rainStatus = 0000;
        break;
    }
}
