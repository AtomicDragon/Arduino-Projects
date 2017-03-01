int pistonPin = 0;
int vexPin = 0;
int flipperPin = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(8,OUTPUT); //Flipper
  pinMode(9,OUTPUT); //Pusher
  pinMode(10,OUTPUT); //Tipper Higher
  pinMode(11,OUTPUT); //Tipper Lower
  pinMode(2, INPUT); //piston Sensor
  pinMode(3, INPUT); //Vex Sensor
  pinMode(4, INPUT); //Flipper Sensor
}

void loop() {
  // put your main code here, to run repeatedly:
  state1();
  state2();
  state3();
}

void state1()
{
  digitalWrite(9, HIGH);
  delay(200);
  digitalWrite(9, LOW);
  delay(100);
  digitalWrite(8, HIGH);
  delay(1000);
  digitalWrite(8, LOW);
  delay(100);
}

void state2()
{
  while(vexPin==LOW)
  {
    vexPin = digitalRead(3);
    delay(1);
  }
  vexPin=0;
  digitalWrite(10, HIGH);
  digitalWrite(11, LOW);
  while(pistonPin==LOW)
  {
    pistonPin = digitalRead(2);
    delay(1);
  }
  pistonPin=0;
  digitalWrite(11, HIGH);
  digitalWrite(10,LOW);
  delay(1000);
  digitalWrite(11, LOW);
}

void state3()
{
  while(flipperPin==LOW)
  {
    flipperPin = digitalRead(4);
    delay(1);
  }
  flipperPin=0;
}
