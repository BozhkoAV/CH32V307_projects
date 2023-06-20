#include "TM1637.h"
#include "gpio.h"

const char segmentMap0[] = {0x00};

const char segmentMap[] = {
    0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, // 0-7
    0x7f, 0x6f, 0x77, 0x7c, 0x39, 0x5e, 0x79, 0x71, // 8-9, A-F
    0x00
};

void TM1637_ClkHigh(void)
{
    GPIO_WriteBit(CLK_PORT , CLK_PIN , Bit_SET);
}

void TM1637_ClkLow(void)
{
    GPIO_WriteBit(CLK_PORT , CLK_PIN , Bit_RESET);
}

void TM1637_DataHigh(void)
{
    GPIO_WriteBit(DIO_PORT, DIO_PIN,  Bit_SET);
}

void TM1637_DataLow(void)
{
    GPIO_WriteBit(DIO_PORT, DIO_PIN,  Bit_RESET);
}

void TM1637_Init(void)

{   TM1637_SetBrightness(7);
    TM1637_SetBrightness(8);
}


void TM1637_DisplayDecimal(int number, short int displaySeparator, short int show0)
{
    unsigned char digitArr[4];
      int v=number;
    for (int i = 0; i < 4; ++i) {
            if((show0==1) && (v==0))  digitArr[i] = segmentMap0[v % 10];
      else digitArr[i] = segmentMap[v % 10];

        if (i == 2 && displaySeparator) {
            digitArr[i] |= 1 << 7;
        }
        v /= 10;
    }

    TM1637_Start();
    TM1637_WriteByte(0x40);
    TM1637_ReadResult();
    TM1637_Stop();

    TM1637_Start();
    TM1637_WriteByte(0xc0);
    TM1637_ReadResult();

    for (int i = 0; i < 4; ++i) {
              if(number==0) digitArr[0]=0x3f;
              TM1637_WriteByte(digitArr[3 - i]);
        TM1637_ReadResult();
    }

    TM1637_Stop();
}

void TM1637_SetBrightness(char brightness)
{
    TM1637_Start();
    TM1637_WriteByte(0x87 + brightness);
    TM1637_ReadResult();
    TM1637_Stop();
}

void TM1637_Start(void)
{
    TM1637_ClkHigh();
    TM1637_DataHigh();
    Delay_Us(2);
    TM1637_DataLow();
}

void TM1637_Stop(void)
{
    TM1637_ClkLow();
    Delay_Us(2);
    TM1637_DataLow();
    Delay_Us(2);
    TM1637_ClkHigh();
    Delay_Us(2);
    TM1637_DataHigh();
}

void TM1637_ReadResult(void)
{
    TM1637_ClkLow();
    Delay_Us(5);

    TM1637_ClkHigh();
    Delay_Us(2);
    TM1637_ClkLow();
}

void TM1637_WriteByte(unsigned char b)
{
    for (int i = 0; i < 8; ++i) {
        TM1637_ClkLow();
        if (b & 0x01) {
            TM1637_DataHigh();
        }
        else {
            TM1637_DataLow();
        }
        Delay_Us(3);
        b >>= 1;
        TM1637_ClkHigh();
        Delay_Us(3);
    }
}

