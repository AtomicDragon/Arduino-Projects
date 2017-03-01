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

VoiceShield vs(80);              // Create a instance of the Voice Shield called "vs" with 80 sound slots

int i = 1;
int Sentence[16];
int Phs1[] = {
  31, 34, 42, 43, 255};            // "How much is the train?"
int Phs2[] = {
  51, 48, 34, 42, 40, 255};        // "Hello, where is the store?"         
int Phs3[] = {
  57, 33, 38, 52, 1, 50, 255};     // "Could I please have one hotdog?"

void setup()
{

}

void loop()
{
  for(i =1; i < 4; i++)
  {
  SayPhrase(i);
  delay(1000);                   // Wait 1 secounds
  }
}

void SayPhrase(int phrase)                                                  // Play PHRASE of your sounds
{
  int loca = 0;
  int TEMP = 0;
  switch (phrase)
  {
  case 1:
    for(loca =0; loca < (sizeof(Phs1)/sizeof(int)); loca++)
    {
      Sentence[loca] = Phs1[loca];
    }
    break;
  case 2:
    for(loca =0; loca < (sizeof(Phs2)/sizeof(int)); loca++)
    {
      Sentence[loca] = Phs2[loca];
    }
    break;
  case 3:
    for(loca =0; loca < (sizeof(Phs3)/sizeof(int)); loca++)
    {
      Sentence[loca] = Phs3[loca];
    }
    break;
  default:
    Sentence[0] = 255;
  }


  for(loca=0; loca < 15; loca = loca +1)
  {
    if(Sentence[loca] == 255)
    {
      loca = 15;
    }
    else
    {
        vs.ISDPLAY_to_EOM(Sentence[loca]);
    }
  }
}
