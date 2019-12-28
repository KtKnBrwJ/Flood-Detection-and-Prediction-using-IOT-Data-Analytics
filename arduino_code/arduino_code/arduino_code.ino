#include <dht.h>
#define DHT11_PIN 7

dht DHT;

const int trigPin = 9;
const int echoPin = 10;
int FloatSensor=2;   
int led=3;           
int buttonState = 1;
const int sensorMin = 0; 
const int sensorMax = 1024; 
long duration;
int distance;

void setup(){

  pinMode(trigPin, OUTPUT); // Sets the trigPin as an Output
  pinMode(echoPin, INPUT); // Sets the echoPin as an Input
  pinMode(FloatSensor, INPUT_PULLUP);
  pinMode (led, OUTPUT);

  Serial.begin(9600);
}

void loop()
{
  temparature_humidity_sensor();
  ultrasonic_sensor();
  magnetic_float_sensor();
  rain_sensor();
  delay(2000);
  
}

void temparature_humidity_sensor(){
  int chk = DHT.read11(DHT11_PIN);
  Serial.print(DHT.temperature);
  Serial.print(" ");
  Serial.print(DHT.humidity);
  Serial.print(" ");
}

void ultrasonic_sensor(){
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
  // Prints the distance on the Serial Monitor
  Serial.print(distance);
  Serial.print(" ");
}

void magnetic_float_sensor(){
  buttonState = digitalRead(FloatSensor); 
  if (buttonState == HIGH) 
  { 
    digitalWrite(led, HIGH);
    Serial.print(buttonState);
    Serial.print(" "); 
  } 
  else 
  { 
    digitalWrite(led, LOW);
    Serial.print(buttonState);
    Serial.print(" "); 
  } 
}

void rain_sensor(){
  int sensorReading = analogRead(A0);
  int range = map(sensorReading, sensorMin, sensorMax, 0, 3);

  switch (range)
    {
      case 0:
        Serial.println("1111");
        break;

      case 1:
        Serial.println("1010");
        break;

      case 2:
        Serial.println("0000");
        break;
    }
}
