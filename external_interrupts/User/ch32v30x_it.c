/********************************** (C) COPYRIGHT *******************************
* File Name          : ch32v30x_it.c
* Author             : WCH
* Version            : V1.0.0
* Date               : 2021/06/06
* Description        : Main Interrupt Service Routines.
*********************************************************************************
* Copyright (c) 2021 Nanjing Qinheng Microelectronics Co., Ltd.
* Attention: This software (modified or not) and binary are used for 
* microcontroller manufactured by Nanjing Qinheng Microelectronics.
*******************************************************************************/
#include "ch32v30x_it.h"

void NMI_Handler(void) __attribute__((interrupt("WCH-Interrupt-fast")));
void HardFault_Handler(void) __attribute__((interrupt("WCH-Interrupt-fast")));
void EXTI0_IRQHandler(void) __attribute__((interrupt("WCH-Interrupt-fast")));
void EXTI1_IRQHandler(void) __attribute__((interrupt("WCH-Interrupt-fast")));
void EXTI2_IRQHandler(void) __attribute__((interrupt("WCH-Interrupt-fast")));
void EXTI3_IRQHandler(void) __attribute__((interrupt("WCH-Interrupt-fast")));
void EXTI4_IRQHandler(void) __attribute__((interrupt("WCH-Interrupt-fast")));

/*********************************************************************
 * @fn      NMI_Handler
 *
 * @brief   This function handles NMI exception.
 *
 * @return  none
 */
void NMI_Handler(void)
{
}

/*********************************************************************
 * @fn      HardFault_Handler
 *
 * @brief   This function handles Hard Fault exception.
 *
 * @return  none
 */
void HardFault_Handler(void)
{
  while (1)
  {
  }
}

void EXTI0_IRQHandler(void)
{
  if(EXTI_GetITStatus(EXTI_Line0)!=RESET)
  {
    printf("Run at EXTI0\r\n");
    EXTI_ClearITPendingBit(EXTI_Line0);     /* Clear Flag */
  }
}

void EXTI1_IRQHandler(void)
{
  if(EXTI_GetITStatus(EXTI_Line1)!=RESET)
  {
    printf("Run at EXTI1\r\n");
    EXTI_ClearITPendingBit(EXTI_Line1);     /* Clear Flag */
  }
}

void EXTI2_IRQHandler(void)
{
  if(EXTI_GetITStatus(EXTI_Line2)!=RESET)
  {
    printf("Run at EXTI2\r\n");
    EXTI_ClearITPendingBit(EXTI_Line2);     /* Clear Flag */
  }
}

void EXTI3_IRQHandler(void)
{
  if(EXTI_GetITStatus(EXTI_Line3)!=RESET)
  {
    printf("Run at EXTI3\r\n");
    EXTI_ClearITPendingBit(EXTI_Line3);     /* Clear Flag */
  }
}

void EXTI4_IRQHandler(void)
{
  if(EXTI_GetITStatus(EXTI_Line4)!=RESET)
  {
    printf("Run at EXTI4\r\n");
    EXTI_ClearITPendingBit(EXTI_Line4);     /* Clear Flag */
  }
}
