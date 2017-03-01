//  *********************************************************************************************
//  *                                                                                           *
//  *                                  SpikenzieLabs.com                                        *
//  *                                                                                           *
//  *                               Arduino Voice Shield_FW                                     *
//  *                                                                                           *
//  *                                                                                           *
//  *********************************************************************************************
//
// BY: MARK DEMERS 
// July 2012
// VERSION 1.2
//
// Changes:
// July 2012
// 1. Renamed Pins ISD uses because the conflict with new standard pin definition in Arduino 1.0+
// 2. Included compile time header files for updated Arduino definitions.


extern "C" {
  #include <inttypes.h>
}


 #if defined(ARDUINO) && ARDUINO >= 100
  #include "Arduino.h"
  #else
  #include "WProgram.h"
  #endif

#include "VoiceShield.h"


VoiceShield::VoiceShield(uint8_t SOUNDBYTES)
{
  _SOUNDBYTES = SOUNDBYTES;
  pinMode(ISDSS, OUTPUT);
  pinMode(ISDMOSI, OUTPUT);
  pinMode(ISDSCLK, OUTPUT);
  pinMode(ISDINTU, INPUT);

  digitalWrite(ISDSS, HIGH);
  digitalWrite(ISDSCLK, LOW);
}

void VoiceShield::SPI_TX(uint8_t SPIbits, uint8_t ISDcont, uint8_t SlotNumb)
{
  //                       Condition & Format data here for 16 or 8 bit ISDMESSAGE
  int i =0;
  int ISDADDRESS = 0;
  ISDADDRESS = ((SlotNumb) * (1200/_SOUNDBYTES));
  unsigned int TESTTEMP =0;
  unsigned int ISDMESSAGE = 0;         // Full two bytes to send to ISD Chip

  if(SPIbits == 16)                                // True if 8 bit SPI trasnmition
  {
    for(i=1; i < 12; i = i + 1)                   // 11 Bits A0 to A10
    {
      TESTTEMP = 1 & ISDADDRESS;
      ISDMESSAGE = ISDMESSAGE | TESTTEMP;
      if (i < 11)
      {
        ISDMESSAGE = ISDMESSAGE << 1;
        ISDADDRESS = ISDADDRESS >> 1;
      }
    }

    ISDMESSAGE = ISDMESSAGE << 1;

    for(i=1; i < 6; i = i +1)                      // 5 Bits C0 to C4
    {
      TESTTEMP = 16 & ISDcont;
      TESTTEMP = TESTTEMP >>4;
      ISDMESSAGE = ISDMESSAGE | TESTTEMP;
      if (i < 5)
      {
        ISDMESSAGE = ISDMESSAGE << 1;
        ISDcont = ISDcont << 1;
      }
    }
  } 
  else                                          // True if 8 bit SPI trasnmition
  {
    for(i=1; i < 6; i = i +1)                      // 5 Bits C0 to C4
    {
      TESTTEMP = 16 & ISDcont;
      TESTTEMP = TESTTEMP >>4;
      ISDMESSAGE = ISDMESSAGE | TESTTEMP;
      if (i < 5)
      {
        ISDMESSAGE = ISDMESSAGE << 1;
        ISDcont = ISDcont << 1;
      }
    }
  }

  digitalWrite(ISDSS, HIGH);                        // Get ready, make sure not selected and clock low
  digitalWrite(ISDSCLK, LOW);

  digitalWrite(ISDSS, LOW);                         // Select the ISD Chip
  delay(5);                                      // This might not be needed

  for(i=1; i < (SPIbits+1); i = i +1)
  {
    TESTTEMP = (ISDMESSAGE >> (SPIbits-1));                                  // test bit 16 of ISDMESSAGE
    TESTTEMP = TESTTEMP & 1;
    if (TESTTEMP == 0)                                              // SET or Clear MOSI
    {
      digitalWrite(ISDMOSI, LOW);
    } 
    else
    {
      digitalWrite(ISDMOSI, HIGH);
    }

    digitalWrite(ISDSCLK, HIGH);                                      // SET SCLK
    delay(5);                                                      // Wait
    digitalWrite(ISDSCLK, LOW);                                       // Clear Clock
    ISDMESSAGE = ISDMESSAGE << 1;                                  // Shift ISDMESSAGE LEFT by 1
  }

  // delay(25);                                                        // This might not be needed
  digitalWrite(ISDSS, HIGH);                                           // Done UN-Select the ISD Chip & let it start command
  digitalWrite(ISDSCLK, LOW);
}

void VoiceShield::ISDRECORD(uint8_t VS_ADDRESS)
{
  SPI_TX(8,POWERUP,0);
  delay(25);
  SPI_TX(8,POWERUP,0);
  delay(50);
  SPI_TX(16, SETREC, VS_ADDRESS);
}

void VoiceShield::ISDPLAY(uint8_t VS_ADDRESS)
{
  SPI_TX(8,POWERUP,0);							 // On Spec Sheet POWERUP is required, but is it?
  delay(25);
  SPI_TX(16,SETPLAY,VS_ADDRESS);
}

void VoiceShield::ISDPLAY_to_EOM(uint8_t VS_ADDRESS)
{
  int TEMP = 0;
  SPI_TX(8,POWERUP,0);							 // On Spec Sheet POWERUP is required, but is it?
  delay(25);
  SPI_TX(16,SETPLAY,VS_ADDRESS);
   do
      {
    TEMP = digitalRead(ISDINTU);		             // LOW at END of Message
      } 
   while (TEMP == 1);
}

void VoiceShield::ISDSTOP()
{
  SPI_TX(8,STOP,0);
  delay(50);
}

uint8_t VoiceShield::SOUNDSLOTS()
{
	return _SOUNDBYTES;
}

uint8_t VoiceShield::ISDEOM()
{
	int TEMP = 0;
    TEMP = digitalRead(ISDINTU);		// LOW at END of Message
    return TEMP;
}

