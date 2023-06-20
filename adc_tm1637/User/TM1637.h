#ifndef INC_TM1637_H_
#define INC_TM1637_H_

#include "ch32v30x.h"

#define DISABLE_ZEROS 1
#define ENABLE_ZEROS 0

void TM1637_Init(void);
void TM1637_DisplayDecimal(int number, short int displaySeparator, short int show0);
void TM1637_SetBrightness(char brightness);
void TM1637_Start(void);
void TM1637_Stop(void);
void TM1637_ReadResult(void);
void TM1637_WriteByte(unsigned char b);
void TM1637_DelayUsec(unsigned int i);
void TM1637_ClkHigh(void);
void TM1637_ClkLow(void);
void TM1637_DataHigh(void);
void TM1637_DATALow(void);

#endif
