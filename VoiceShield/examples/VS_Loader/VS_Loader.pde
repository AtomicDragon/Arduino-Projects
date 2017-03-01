//  *****************************************************************************************************************
//  *                                                                                                               *
//  *                                         SpikenzieLabs.com                                                     *
//  *                                                                                                               *
//  *                                        Voice Shield Loader                                                    *
//  *                                                                                                               *
//  *                                                                                                               *
//  *****************************************************************************************************************
//
// BY: MARK DEMERS 
// Dec 2008
// VERSION 1.0
//
// Brief:
// Sketch used to load SpikenzieLabs' Arduino Voice Shield with audio. 
// Uses VS_Programmer, programmed in Processing, availiable at www.spikenzielabs.com
// 
//
// LEGAL:
// This code is provided as is. No guaranties or warranties are given in any form. It is your responsibilty to 
// determine this codes suitability for your application.


#include <VoiceShield.h>             // USES VoiceShield Library 

VoiceShield vs(80);                  // Create VoiceShield class with 80 sound bytes

int i = 0;

int val[3];                          // Serial Programming reception array
int COMMAND = 0;                     // Programming Command 1 = STOP, 2 = Play,  3 = Record, 4 = Report bytes
int ADDRESS = 0;                     // Sound slot to record into or play from


void setup()
{
  Serial.begin(9600);                                           // connect to the serial port
}

void loop() 
{

  if (Serial.available() > 0)                                   // Validate data only if received 
  {
    for(i=0; i < 3; i = i +1){
      val[i] = Serial.read();                                   // read the incoming byte:

      delay(100);
    }

    if(val[0] == 255)
    {
      if(val[1] >= 1 && val[1]<=4)
      {
        if(val[2] >= 0 && val[2] <= 254)
        {
          COMMAND = val[1];
          ADDRESS = val[2];

          switch (COMMAND)
          {
          case 1:
            vs.ISDSTOP();
            break;
          case 2:
            vs.ISDPLAY(ADDRESS);
            break;
          case 3:
            vs.ISDRECORD(ADDRESS);
            break;
          case 4:
            Serial.print(vs.SOUNDSLOTS(), DEC);                 // Lets the Programmer know how many SoundBytes
            break;
          default:
            Serial.println("ERROR");                            // Should never be here
          }
        }
      }
    }

  }
}
