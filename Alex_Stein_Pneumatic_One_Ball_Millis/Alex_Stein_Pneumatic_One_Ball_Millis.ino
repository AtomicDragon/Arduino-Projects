/*
  Pneumatic One Ball
  Move one ball around the course by waiting 1 second each

  This example code is in the public domain.
 */

// Each valve is connected to digital output
// give it a name:
const int valve1 = 8;//Flinger
const int valve2 = 9;//Pusher
const int valve3 = 10;//Tipper Extends
const int valve4 = 11;//Tipper Retracts
const int pistonSensor = 2;
const int switch1  = 3; //VexSwitch
const int switch2 = 4;  //Regular Switch

int switch1WasPushed = 0;       //Boolean for Switch 1
int switch2WasPushed = 0;       //Boolean for Switch 2
int pistonSensorWasPushed = 0;  //Boolean for Piston Sensor
int switch1State = 0;           //Detects if Switch1 is being Pushed
int switch2State = 0;           //Detects if Switch2 is being Pushed
long millisSwitch1 = 0;         //Time when Switch1 was pushed
long millisSwitch2 = 0;         //Time when Switch2 was pushed
long millisPiston = 0;          //Time when Piston was sensed

// the setup routine runs once when you press reset:
void setup() {
  // initialize the digital pin as an output.
  pinMode(valve1, OUTPUT);
  pinMode(valve2, OUTPUT);  
  pinMode(valve3, OUTPUT);
  pinMode(valve4, OUTPUT);

  pinMode(pistonSensor, INPUT);
  pinMode(switch1, INPUT);
  pinMode(switch2, INPUT);  
}

// the loop routine runs over and over again forever:
void loop() {
  
  switch1State = digitalRead(switch1);
  switch2State = digitalRead(switch2);
  if(switch1State == HIGH)
  {
      switch1WasPushed = 1;
  }
  if(switch2State == HIGH)
  {
      switch2WasPushed = 1);
  }
  if(switch1WasPushed == 1)
  {
    switch1Pushed();
  }
  if(switch2WasPushed == 2)
  {
    switch2Pushed();
  }
}

void switch1Pushed()
{
  unsigned long currentMillis = millis();
  if(currentMillis - millisSwitch1 > 250){
    digitalWrite(valve3, HIGH);   // Open valve 3 (extends)
    if(digitalRead(pistonSensor) == LOW)
    {
      pistonSensorWasPushed = 1;
  digitalWrite(valve3, LOW);    // Close valve 3 (stays still)
  delay(1000);               // wait for a second
  digitalWrite(valve4, HIGH);   // Open valve 4 (Retracts)
  delay(1000);               // wait for a second
  digitalWrite(valve4, LOW);    // Close valve 4 (stays still)          
}

void switch2Pushed()
{
  digitalWrite(valve1, HIGH);   // Open valve 1 (extends)
  delay(1000);               // wait for a second
  digitalWrite(valve1, LOW);    // Close valve 1 (retracts)
  delay(700);               // wait for a second
  digitalWrite(valve2, HIGH);   // Open valve 2 (extends)
  delay(200);               // wait for a second
  digitalWrite(valve2, LOW);    // Close valve 2 (retracts)
  delay(100);               // wait for a second
}
