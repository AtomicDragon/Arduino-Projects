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

#ifndef VoiceShield_h
#define VoiceShield_h

#include <inttypes.h>

#define  POWERUP 4                   //   0   0   1   0   0 
#define  SETPLAY 7                   //   0   0   1   1   1
#define  SETREC 5                    //   0   0   1   0   1
#define  STOP 12                     //   0   1   1   x   0  

#define ISDSS 5                          // ISD Pin mapping to Arduino = ISD Select, LOW = Selected
#define ISDMOSI 2                        // ISD Pin mapping to Arduino = Master Out Slave In
#define ISDSCLK 3                        // ISD Pin mapping to Arduino = Serial clock
#define ISDINTU 4                        // ISD Pin mapping to Arduino = INT or EOM ISD output

class VoiceShield
{
  public:
    VoiceShield(uint8_t SOUNDBYTES);
    void ISDRECORD(uint8_t VS_ADDRESS);
    void ISDPLAY(uint8_t VS_ADDRESS);
    void ISDPLAY_to_EOM(uint8_t VS_ADDRESS);
    void ISDSTOP();
    uint8_t SOUNDSLOTS();
    uint8_t ISDEOM();
  private:
  	void SPI_TX(uint8_t SPIbits, uint8_t ISDcont, uint8_t SlotNumb);
  	uint8_t _SOUNDBYTES;
};

#endif

