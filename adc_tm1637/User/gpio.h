#ifndef INC_GPIO_H_
#define INC_GPIO_H_

#include "ch32v30x.h"

#define CLK_PORT GPIOB
#define DIO_PORT GPIOB
#define CLK_PIN GPIO_Pin_0
#define DIO_PIN GPIO_Pin_1

void GPIO_SETUP(void);

#endif
