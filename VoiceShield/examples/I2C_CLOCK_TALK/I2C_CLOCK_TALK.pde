//  *****************************************************************************************************************
//  *                                                                                                               *
//  *                                         SpikenzieLabs.com                                                     *
//  *                                                                                                               *
//  *                                 USES:     Voice Shield                                                        *
//  *                                     &    I2C LCD Driver                                                       *
//  *                                                                                                               *
//  *                                     Demo Program Clock Talk                                                   *
//  *                                                                                                               *
//  *****************************************************************************************************************
//
// BY: MARK DEMERS 
// Dec. 2008
// VERSION: 0.2
//
// DESCRIPTION:
// This is a demo program to show how to make a talking clock. Is uses the I2C LCD interface and the Voice Shield
// availiable at Spikenzielabs.com.
//
// The time is displayed on the lCD display, two buttons are used to set the hour and minute, once a minute the
// time is spoken by the Voice Shield.
//
//
// HOOK-UP:
//  1. Voice Shield plug in onto the Arduino
//  2. Hook, power, I2C, and crystal to PCF8583 on a bread board.
//
//  3. SIGNAL     I2C LCD BOARD    -    ARDUINO
//   Ground          GND                 GND
//    VCC            5V                  5V
//    SDA**          SDA               Analog 4
//    SCL**          SCL               Analog 5
//
//   The button are wired with a normally open (NO) switch to ground. (Pressing the button will contact the 
//   ground signal) J3 on the PCB has an extra ground and pins for buttons 1 to 5.
//
// ** I2C communications require a pull-up resistor on both the SCL and SDA lines. There must be a 4.7k through
//    10kohm resistor on both the SDA and SCL pulling them up to VCC. Even if you are using other I2C devices
//    use only one set of pull-up resistors.
//    Pull-up resistors are not included on the I2C-SPI LCD board, for the following reasons; they are not 
//    required when the board is used with the SPI interface, only one set of resisters is required for the I2C
//    bus (if you where to use more them one board there would be too many), and it gives you more control.
//
//  
//
// USAGE:
// 1. Disconnect the power and hook-up the Arduino and the I2C Board as described above.
// 2. Set your I2C address. (Up to 7 I2C Boards and be used on the same I2C bus.)
//    See below in the define section for this line
//                     #define		MCP23017	B00100xxx 
//                                                       the "xxx" is your board's changeable I2C Address 
//    Use the dip switch on the I2C board to modify the address. Switch position 1 is the LSB, rightmost "x" above.
// 3. Power the board and upload the sketch. 
// 4. You should see a message and a counter on your LCD. If you hooked up buttons and are pressing one, you should 
//    also see that message. You may need to adjust the contrast POT (blue square on PCB) to see the display properly.               

//
//
//
// LEGAL:
// This code is provided as is. No guaranties or warranties are given in any form. It is up to you to determine
// this codes suitability for your application.
//




#include <Wire.h>   // REQUIRED                                                   Used for the I2C Communications
#include <VoiceShield.h>

VoiceShield vs(80);

//*******************************************************************************************************************
// REQUIRED							                                Define Statements 
//*******************************************************************************************************************

// Port Expander
#define		MCP23017	B00100000	//MCP23017 I2C Address was B01000000
//                                    xxx <- These are the I2C address bits

#define		IOCON		0x0A		// MCP23017 Config Reg.

#define		IODIRA		0x00		// MCP23017 address of I/O direction
#define		IODIRB		0x01		// MCP23017 1=input

#define		IPOLA		0x02		// MCP23017 address of I/O Polarity
#define		IPOLB		0x03		// MCP23017 1= Inverted

#define		GPIOA		0x12		// MCP23017 address of GP Value
#define		GPIOB		0x13		// MCP23017 address of GP Value

#define		GPINTENA	0x04		// MCP23017 IOC Enable
#define		GPINTENB	0x05		// MCP23017 IOC Enable

#define		INTCONA		0x08		// MCP23017 Interrupt Cont 
#define		INTCONB		0x09		// MCP23017 1= compair to DEFVAL(A or B) 0= change

#define		DEFVALA		0x06		// MCP23017 IOC Default value
#define		DEFVALB		0x07		// MCP23017 if INTCONA set then INT. if diff. 

#define		GPPUA		0x0C		// MCP23017 Weak Pull-Ups
#define		GPPUB		0x0D		// MCP23017 1= Pulled HIgh via internal 100k

// LCD
#define		ClrLCD		0x01		// clear the LCD
#define		CrsrHm		0x02		// move cursor to home position
#define		CrsrLf		0x10		// move cursor left
#define		CrsrRt		0x14		// move cursor right
#define		DispLf		0x18		// shift displayed chars left
#define		DispRt		0x1C		// shift displayed chars right
#define		DDRam		0x80		// Display Data RAM control
#define		ddram2		0xC0		// 9th position of display (not in next 

#define		RS_pin		B00000100
#define		RW_pin		B00000010
#define		E_pin		B00000001


// PCF8583 RTC
#define		PCF8583         B01010001
#define		RTCCONTROL    	B00000000
#define		RTCSECOUND	B00000010
#define		RTCMINUTE	B00000011
#define		RTCHOUR    	B00000100
#define         AMPM            B10000000        // MSB set = 12 hour mode


//*******************************************************************************************************************
//								                                   VARIABLE INITS
//*******************************************************************************************************************

byte LCDCONT    = 0;        // REQUIRED
byte button = 0;            // REQUIRED
int  i  =0;                 // REQUIRED

int buttonPress    =0;
int count  = 0;
int temp = 0;
int time = 0;

int HB =0;
int HS =0;
int MB =0;
int MS =0;
int OLDMINUTE  =0 ;
int TEMP = 0;

// SIZER        "0123456789012345678901234567890123456789"
char mess[16] = "I2C LCD ";  // Hello style it's working message
char mess1[16] ="Button: ";  // Part of the "a button is being pressed" message
char NUMB[4] =  "000";

//*******************************************************************************************************************
// REQUIRED								                                    SET-UP 
//*******************************************************************************************************************

void setup()
{
  Wire.begin();                                                        // join i2c bus (address optional for master)
  portexpanderinit();
  delay(200);
  lcdinit();
  delay(500);
  LCDcmd(ClrLCD);

  Serial.begin(9600);    // Only used for debugging - not required

  rtcinit();
}

//*******************************************************************************************************************
//								                                        MAIN LOOP
//*******************************************************************************************************************

void loop()
{
  I2C_RX(PCF8583,RTCHOUR); 
  temp = (time & B00110000);
  temp = temp >> 4;

  HB = temp;

  temp = temp +48;
  LCDwr(temp);
  temp = (time & B00001111);

  HS = temp;

  temp=temp+48;
  LCDwr(temp);
  LCDwr(B00111010);

  I2C_RX(PCF8583,RTCMINUTE); 
  temp = (time & B11110000);
  temp = temp >> 4;

  MB=temp;

  temp = temp +48;
  LCDwr(temp);
  temp = (time & B00001111);

  MS=temp;

  temp= temp + 48;
  LCDwr(temp);

  LCDwr(B00111010);

  I2C_RX(PCF8583,RTCSECOUND); 
  temp = (time & B11110000);
  temp = temp >> 4;
  temp = temp +48;
  LCDwr(temp);
  temp = (time & B00001111)+48;
  LCDwr(temp);

  if(MS != OLDMINUTE)
  {
    speektime();
  }
  OLDMINUTE = MS;

  checkbutton();

  LCDcmd(CrsrHm);
  delay(200);

}

//*******************************************************************************************************************
//								                         Functions and Subroutines
//*******************************************************************************************************************


//*******************************************************************************************************************
// REQUIRED								                                 I2C TX RX
//*******************************************************************************************************************
void I2C_TX(byte device, byte regadd, byte tx_data)                              // Transmit I2C Data
{
  Wire.beginTransmission(device);
  Wire.send(regadd); 
  Wire.send(tx_data); 
  Wire.endTransmission();
}

void I2C_RX(byte devicerx, byte regaddrx)                                       // Receive I2C Data
{
  Wire.beginTransmission(devicerx);
  Wire.send(regaddrx); 
  Wire.endTransmission();
  Wire.requestFrom(int(devicerx), 1);   

  byte c = 0;
  if(Wire.available())
  {
    byte c = Wire.receive();       
    time = c;    
    button = c >>3;
  }
}

//*******************************************************************************************************************
// REQUIRED								                                  LCD INIT
//*******************************************************************************************************************

void lcdinit()
{
  // Only used with port expander
  LCDCONT = RS_pin | E_pin;
  I2C_TX(MCP23017,GPIOB,LCDCONT);

  delay(50);
  LCDcmd(B00110000);                 // Standard Hitachi initialization for 8-bit mode form sepc sheets
  delay(60);
  LCDcmd(B00110000);    
  delay(60);
  LCDcmd(B00110000);      
  delay(60);
  LCDcmd(B00111000);      
  delay(60);
  LCDcmd(B00001000);        
  delay(60);
  LCDcmd(ClrLCD);          
  delay(60);
  LCDcmd(B00000110); 	
  delay(60);
  LCDcmd(B0001100);        	
  delay(60);
}

//*******************************************************************************************************************
// REQUIRED								                         PORTEXPANDER INIT
//*******************************************************************************************************************
void portexpanderinit()
{
  // --- Set I/O Direction
  I2C_TX(MCP23017,IODIRB,B11111000);
  I2C_TX(MCP23017,IODIRA,B00000000);
  //  --- Set I/O Polarity
  I2C_TX(MCP23017,IPOLA,B00000000);
  I2C_TX(MCP23017,IPOLB,B11111000);
  //  --- Set ALL Bits of GPIOA
  I2C_TX(MCP23017,GPIOA,B00000000);
  // --- Set Weak Pull-Up on Bits 7 of GPIOB
  I2C_TX(MCP23017,GPPUB,B11111000);
  // --- Set Default on Bits 7 of GPIOB
  I2C_TX(MCP23017,DEFVALB,B00000000);
  // --- Set Use Default on Bits 7 of GPIOB
  I2C_TX(MCP23017,INTCONB,B10000000);
  // --- Set IOC on Bits 7 of GPIOB
  I2C_TX(MCP23017,GPINTENB,B10011000);
  // --- Set active low of int pin
  I2C_TX(MCP23017,IOCON,B00110000);
}

//*******************************************************************************************************************
// REQUIRED								                         PORTEXPANDER INIT
//*******************************************************************************************************************
void rtcinit()
{
  // --- Set I/O Direction
  I2C_TX(PCF8583,RTCCONTROL,B00000000);
  I2C_TX(PCF8583,RTCHOUR,B10010000);

}

//*******************************************************************************************************************
// REQUIRED								                       LCD WRITE / COMMAND
//*******************************************************************************************************************
void LCDcmd(byte cmdlcd)
{
  LCDCONT =0;                            // was bcf RS_pin
  I2C_TX(MCP23017,GPIOB,LCDCONT);
  LCDwr(cmdlcd);
  delay(20);
}

void LCDwr(byte lcdChar)
{
  I2C_TX(MCP23017,GPIOA,lcdChar);
  LCDCONT = LCDCONT | E_pin;              // If RS is set then it stays set
  delay(2);
  I2C_TX(MCP23017,GPIOB,LCDCONT);
  LCDCONT = RS_pin;
  I2C_TX(MCP23017,GPIOB,LCDCONT);
}


//*******************************************************************************************************************
//								                   SEND DECIMAL NUMBER TO DISPLAY
//*******************************************************************************************************************
void dispnumb(int numbvar)
{
  //int THUS= abs(numbvar/1000);
  int HUNDS= abs(numbvar/100);
  int TENS = abs((numbvar - (HUNDS*100))/10);
  int ONES = abs(numbvar-(HUNDS*100)-(TENS*10));

  NUMB[0] =  HUNDS+48;                                                        // +48 for ASCII conversion
  NUMB[1] =  TENS+48;
  NUMB[2] =  ONES+48;

  for(i=0;i<3;i++)
  {
    LCDwr(NUMB[i]);                                                           // Print-Out 3 digit number at cursor
  }
}

//*******************************************************************************************************************
//								                 READ IF BUTTONS ARE BEING PRESSED
//*******************************************************************************************************************
void checkbutton()                            // Use serial monitor at 9600bps to see buttons that are pressed
{
  I2C_RX(MCP23017,GPIOB);
  buttonPress = int(button);
  switch (buttonPress)                        
  {
  case 1:
    // Serial.println("Minute +");

    MS = MS +1;
    if (MS == 10)
    {
      MS = 0;
      MB = MB +1;

      if(MB == 6)
      {
        MB = 0;
      }
    }
    TEMP = MB;
    TEMP= TEMP << 4;
    TEMP = TEMP | MS;
    I2C_TX(PCF8583,RTCMINUTE,TEMP);
    OLDMINUTE = MS;
    break;
  case 2:
    // Serial.println("Hour +");
    HS = HS +1;
    if (HS == 10)
    {
      HS = 0;
      HB = HB +1;

      if(HB == 2)
      {
        HB = 0;
      }
    }
    else if(HB == 1 & HS == 3)
    {
      HB = 0;
      HS = 1;
    }
    TEMP = HB;
    TEMP= TEMP << 4;
    TEMP = TEMP | HS;
    TEMP = TEMP | AMPM;
    I2C_TX(PCF8583,RTCHOUR,TEMP);
    break;
  case 4:
    Serial.println("Button-Three");
    break;
  case 8:
    Serial.println("Button-Four");
    break;
  case 16:
    Serial.println("Button-Five");
    break; 
  }
}

void speektime()
{

  // SPEAK THE HOUR  ----------------------------------
  if(HB != 0)
  {
    vs.ISDPLAY_to_EOM(HS+10);
  }
  else
  {
    vs.ISDPLAY_to_EOM(HS);
  }



  // SPEAK THE MINUTES  --------------------------------

  if(MB != 0)

  {

    switch (MB) {
    case 1:
      vs.ISDPLAY_to_EOM(MS+10); // 10 to 19
      break;
    case 2:
      vs.ISDPLAY_to_EOM(20);  // Twenty
      if(MS!=0)
      {
        vs.ISDPLAY_to_EOM(MS);
      }
      break;
    case 3:
      vs.ISDPLAY_to_EOM(21);  // Thrity
      if(MS!=0)
      {
        vs.ISDPLAY_to_EOM(MS);
      }
      break;
    case 4:
      vs.ISDPLAY_to_EOM(22);  // Fourty
      if(MS!=0)
      {
        vs.ISDPLAY_to_EOM(MS);
      }
      break;
    case 5:
      vs.ISDPLAY_to_EOM(23);  // Fifty
      if(MS!=0)
      {
        vs.ISDPLAY_to_EOM(MS);
      }
      break;
    }
  }
  else if(MS != 0)
  {
    vs.ISDPLAY_to_EOM(61);     // The minutes "OH"
    vs.ISDPLAY_to_EOM(MS);     // The minutes
  }
  else
  {
    vs.ISDPLAY_to_EOM(37);   // O'Clock
  }
}
