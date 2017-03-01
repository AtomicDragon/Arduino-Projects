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

int switch1State = 0;
int switch2State = 0;

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
      switch1Pushed();
  }
  if(switch2State == HIGH)
  {
      switch2Pushed();
  }
}

void switch1Pushed()
{
  delay(250);
  digitalWrite(valve3, HIGH);   // Open valve 3 (extends)
  while(digitalRead(pistonSensor) == LOW)delay(1);  // wait until piston sensor senses the presence of the piston
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
