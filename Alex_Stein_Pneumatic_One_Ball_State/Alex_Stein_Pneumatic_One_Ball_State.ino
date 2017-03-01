/*
  Pneumatic One Ball
  Move two balls around the course using states
  Alex Stein 1 and Megan Keeler 2 Group E
  Matthew Stein Mechatronics 2015
 */

// Each valve is connected to digital output
// give it a name:
const int valve1 = 8;//Flinger
const int valve2 = 9;//Pusher
const int valve3 = 10;//Tipper Extends
const int valve4 = 11;//Tipper Retracts
const int pistonSensor = 2; //Position Sensor
const int switch1  = 3; //VexSwitch
const int switch2 = 4;  //Regular Switch

//booleans for sensors
int switch1State = 0;
int switch2State = 0;

// the setup routine runs once when you press reset:
void setup() {
  // initialize the digital pin as an output.
  pinMode(valve1, OUTPUT);
  pinMode(valve2, OUTPUT);  
  pinMode(valve3, OUTPUT);
  pinMode(valve4, OUTPUT);

  // initialize the sensors as inputs.
  pinMode(pistonSensor, INPUT);
  pinMode(switch1, INPUT);
  pinMode(switch2, INPUT);  
}

// the loop routine runs over and over again forever:
void loop() {
  
  state1();
  state2();
  state3();
}

//Pusher to Tipper and Flinger to Pusher
void state1()
{
  digitalWrite(13, HIGH); //Light to show changes in states
  delay(100);
  digitalWrite(13, LOW);
  
  digitalWrite(valve2, HIGH);   // Open valve 2 (Pusher extends)
  delay(300);               // wait for 300 milliseconds
  digitalWrite(valve2, LOW);    // Close valve 2 (Pusher retracts)
  delay(100);               // wait for 100 milliseconds
  digitalWrite(valve1, HIGH);   // Open valve 1 (Flinger extends)
  delay(1000);               // wait for a second
  digitalWrite(valve1, LOW);    // Close valve 1 (Flinger retracts)
  delay(700);               // wait for 700 milliseconds
}

void state2()
{
  digitalWrite(13, HIGH); //Light to show changes in states
  delay(100);
  digitalWrite(13, LOW);
  
  while(digitalRead(switch1) == LOW)delay(1); //wait for Vex switch to trigger
  digitalWrite(valve3, HIGH);   // Open valve 3 (Tipper extends)
  while(digitalRead(pistonSensor) == LOW)delay(1);  // wait until piston sensor senses the presence of the piston
  digitalWrite(valve3, LOW);    // Close valve 3 (Tipper stays still)
  delay(1500);               // wait for 1.5 seconds
  digitalWrite(valve4, HIGH);   // Open valve 4 (Tipper Retracts)
  delay(1000);               // wait for a second
  digitalWrite(valve4, LOW);    // Close valve 4 (Tipper stays still)
}

void state3()
{
  digitalWrite(13, HIGH); //Light to show changes in states
  delay(100);
  digitalWrite(13, LOW);
  
  while(digitalRead(switch2) == LOW)delay(1); //Wait for ball to hit second switch
}
