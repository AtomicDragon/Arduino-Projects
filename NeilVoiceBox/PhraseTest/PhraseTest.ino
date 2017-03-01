//  *****************************************************************************************************************
//  *                                                                                                               *
//  *                                         SpikenzieLabs.com                                                     *
//  *                                                                                                               *
//  *                                         Basic Phrase Talk                                                     *
//  *                                                                                                               *
//  *                                                                                                               *
//  *****************************************************************************************************************
//
// BY: MARK DEMERS 
// Jan 2009
// VERSION 0.1
//
// Brief:
// Sketch uses SpikenzieLabs' Voice Shield to play word in a sequence to make a phrase.
// "Speaks" a predefined sentence, waits 1 second, says the next and after it is done it starts again.
//
// Hook Up:
// 
// Requires Ardunio and VoiceShield (Pre-program VoiceShield with sample sounds and words, from SpikenzieLabs.com)
//
// LEGAL:
// This code is provided as is. No guaranties or warranties are given in any form. It is your responsibilty to 
// determine this codes suitability for your application.

#include <VoiceShield.h>         // Include the Voice Shield Library

VoiceShield vs(16);              // Create a instance of the Voice Shield called "vs" with 80 sound slots


void setup()
{
  for(int i =0; i < 16; i++)
  {
    vs.ISDPLAY_to_EOM(i);
    delay(1000);                   // Wait 1 secounds
  }
}

void loop()
{

}

