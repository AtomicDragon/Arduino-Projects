//  *****************************************************************************************************************
//  *                                                                                                               *
//  *                                         SpikenzieLabs.com                                                     *
//  *                                                                                                               *
//  *                                         Basic Button Talk                                                     *
//  *                                                                                                               *
//  *                                                                                                               *
//  *****************************************************************************************************************
//
// BY: MARK DEMERS 
// Dec 2008
// VERSION 0.1
//
// Brief:
// Sketch uses SpikenzieLabs' Voice Shield to play sound when buttons are pressed.
//
// Hook Up:
// 
// A. Pre-Programming the VoiceShield with the sample audio from SpikenzieLabs
// B. Plug the VoiceShield onto the Ardunio.
// 
// 1. Connect digtal pins 8, 9, 10, 11 and 12 to  5 volts through a 10k resistor. (5x resistors in all)
// 2. Connect one side of a normally open switch to ground. (5x switches)
// 3. Connect the OTHER side of each switch to digital pins 8, 9, 10, 11 and 12.
//
// Use: Load this sketch into the Arduino, then press one button at a time to play the sound.
//
// LEGAL:
// This code is provided as is. No guaranties or warranties are given in any form. It is your responsibilty to 
// determine this codes suitability for your application.
//
//

#include <VoiceShield.h>         // Include the Voice Shield Library

VoiceShield vs(80);              // Create a instance of the Voice Shield called "vs" with 80 sound slots

#define  BUTTON1SOUND 1          // Set these values to the Sound Slot you wish to play
#define  BUTTON2SOUND 2 
#define  BUTTON3SOUND 3 
#define  BUTTON4SOUND 4 
#define  BUTTON5SOUND 5

#define  BUTTON1 8               // These are the Digital Pins on the Ardunio
#define  BUTTON2 9 
#define  BUTTON3 10 
#define  BUTTON4 11 
#define  BUTTON5 12

int pinval = 0;

void setup()
{
    pinMode(BUTTON1, INPUT);
    pinMode(BUTTON2, INPUT);
    pinMode(BUTTON3, INPUT);
    pinMode(BUTTON4, INPUT);
    pinMode(BUTTON5, INPUT);
}

void loop()
{
  pinval = digitalRead(BUTTON1);
  if (pinval == LOW)    vs.ISDPLAY(BUTTON1SOUND); 
  
  pinval = digitalRead(BUTTON2);
  if (pinval == LOW)    vs.ISDPLAY(BUTTON2SOUND); 
  
  pinval = digitalRead(BUTTON3);
  if (pinval == LOW)    vs.ISDPLAY(BUTTON3SOUND); 

  pinval = digitalRead(BUTTON4);
  if (pinval == LOW)    vs.ISDPLAY(BUTTON4SOUND);   
  
  pinval = digitalRead(BUTTON5);
  if (pinval == LOW)    vs.ISDPLAY(BUTTON5SOUND);   
  
  delay(100);
}
