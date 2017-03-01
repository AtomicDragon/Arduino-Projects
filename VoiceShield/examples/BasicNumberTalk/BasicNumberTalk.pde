//  *****************************************************************************************************************
//  *                                                                                                               *
//  *                                         SpikenzieLabs.com                                                     *
//  *                                                                                                               *
//  *                                         Basic Number Talk                                                     *
//  *                                                                                                               *
//  *                                                                                                               *
//  *****************************************************************************************************************
//
// BY: MARK DEMERS 
// Jan 2009
// VERSION 0.1
//
// Brief:
// Sketch uses SpikenzieLabs' Voice Shield to say analog value on analog pin 0.
// First it says the value from the analog read of the pin then it says an the approximate voltage.
//
// Hook Up:
// 
// A. Pre-Programming the VoiceShield with the sample audio from SpikenzieLabs
// B. Plug the VoiceShield onto the Ardunio.
// 
// 1. Connect Analog pin 0 to center pin of a 10k potentiometer.
// 2. Connect one of the other pins to +5 volts and the remaining pin to Ground
//
// Use: Load this sketch into the Arduino, then turn the pot. The Voice Shield will tell you the value once every
//      5 seconds, if changed.
//
// LEGAL:
// This code is provided as is. No guaranties or warranties are given in any form. It is your responsibilty to 
// determine this codes suitability for your application.
//
//

#include <VoiceShield.h>         // Include the Voice Shield Library

VoiceShield vs(80);              // Create a instance of the Voice Shield called "vs" with 80 sound slots

#define  AnalogPin       0       // Analog pin we will use

#define  Point_Word      64      // Sound slot of the word "point", used in phrase "4 point 2 volts"
#define  Volts_Word      62
#define  Hundred_Word    28      // Sound slot of the word "hundred"
#define  Thousand_Word   29      // Sound slot of the word "thousand"

int pinval = 0;
int oldpinval =0;

void setup()
{

}

void loop()
{
  pinval = analogRead(AnalogPin);              // Read the Analog pin
  if(pinval != oldpinval)
  {
    oldpinval = pinval;
    
    SayNumber(pinval);                         // Say the read value from the analog pin
    delay(1000);
  //  SayVolts(pinval);                          // Convert into voltage and say the voltage
  }
  delay (5000);
}

void SayVolts(int volts)
{
  int BigNumber = 0;
  int SmallNumber = 0;
  
    BigNumber = abs(volts/204);                  // Converts analog value into voltage
    SmallNumber = volts - abs(BigNumber*204);    // Converts the decimal places to a single digit
    SmallNumber = abs(204-SmallNumber)/2;
    SmallNumber = abs(100-SmallNumber)/10;
    
    if (BigNumber != 0)
    {
     vs.ISDPLAY_to_EOM(BigNumber);                // Say the volts
    }
     vs.ISDPLAY_to_EOM(Point_Word);               // Say "point"
     vs.ISDPLAY_to_EOM(SmallNumber);              // Say the decimal 
     vs.ISDPLAY_to_EOM(Volts_Word);               // Say "volt" 
}

void SayNumber(int number)
{
  int Thous = 0;
  int Hunds = 0;
  int Tens =  0;
  int Ones =  0;
  
  Thous = abs(number / 1000);
  Hunds = abs((number-(Thous*1000))/100);
  Tens  = abs((number-(Thous*1000)-(Hunds*100))/10);
  Ones  = abs((number-(Thous*1000)-(Hunds*100)-(Tens*10)));
  
  if(Thous != 0)
  {
    vs.ISDPLAY_to_EOM(Thous);
    vs.ISDPLAY_to_EOM(Thousand_Word);
  }
  
    if(Hunds != 0)
  {
    vs.ISDPLAY_to_EOM(Hunds);
    vs.ISDPLAY_to_EOM(Hundred_Word);
  }

    if(Tens != 0)
  {

    switch (Tens) {
    case 1:
      vs.ISDPLAY_to_EOM(Ones+10);       // 10 to 19
      break;
    case 2:
      vs.ISDPLAY_to_EOM(20);            // Twenty
      SayOnes(Ones);
      break;
    case 3:
      vs.ISDPLAY_to_EOM(21);            // Thrity
      SayOnes(Ones);
      break;
    case 4:
      vs.ISDPLAY_to_EOM(22);            // Fourty
      SayOnes(Ones);
      break;
    case 5:
      vs.ISDPLAY_to_EOM(23);            // Fifty
      SayOnes(Ones);
      break;
    case 6:
      vs.ISDPLAY_to_EOM(24);            // Sixty
      SayOnes(Ones);
      break;
    case 7:
      vs.ISDPLAY_to_EOM(25);            // Seventy
      SayOnes(Ones);
      break;  
    case 8:
      vs.ISDPLAY_to_EOM(26);            // Eighty
      SayOnes(Ones);
      break;  
    case 9:
      vs.ISDPLAY_to_EOM(27);            // Ninety
      SayOnes(Ones);
      break;      
    }
  }
  else if(Ones != 0)
  {
    vs.ISDPLAY_to_EOM(Ones);            // Ones
  }
  
  // ----
  
}

void SayOnes(int OneDig)
{
     if(OneDig !=0)
      {
        vs.ISDPLAY_to_EOM(OneDig);
      }
}
