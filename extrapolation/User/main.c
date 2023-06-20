#include "debug.h"

void TIM6_Init()
{
    TIM_TimeBaseInitTypeDef TIM_TimeBaseInitStructure;

    RCC_PCLK1Config(RCC_HCLK_Div1);
    RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM6, ENABLE);

    TIM_TimeBaseInitStructure.TIM_Period = 65536-1;
    TIM_TimeBaseInitStructure.TIM_Prescaler = 1-1;
    TIM_TimeBaseInit( TIM6, &TIM_TimeBaseInitStructure);

    TIM_Cmd(TIM6, ENABLE);
}

int main(void)
{
    NVIC_PriorityGroupConfig(NVIC_PriorityGroup_2);
    SystemCoreClockUpdate();
    Delay_Init();
    USART_Printf_Init(115200);
    printf("SystemClk: %d\r\n",SystemCoreClock);

    int N_in = 2;
    int N_out = 3;

    float buf_x_in[N_in];
    float buf_y_in[N_in];
    float buf_x_out[N_out];
    float buf_y_out[N_out];

    buf_x_in[0] = 0.0; buf_y_in[0] = 2.0;
    buf_x_in[1] = 1.0; buf_y_in[1] = 6.0;
    //buf_x_in[2] = 2.0; buf_y_in[2] = 10.0;
    //buf_x_in[3] = 3.0; buf_y_in[3] = 8.0;
    //buf_x_in[4] = 4.0; buf_y_in[4] = 14.0;
    //buf_x_in[5] = 5.0; buf_y_in[5] = 4.0;
    //buf_x_in[6] = 6.0; buf_y_in[6] = -20.0;
    //buf_x_in[7] = 7.0; buf_y_in[7] = 15.0;

    int time;
    TIM6_Init();
    __asm__("add t0, %0, 0;" : : "r"(N_in));
    __asm__("add t1, %0, 0;" : : "r"(buf_x_in));
    __asm__("add t2, %0, 0;" : : "r"(buf_y_in));
    __asm__("add t3, %0, 0;" : : "r"(N_out));
    __asm__("add t4, %0, 0;" : : "r"(buf_x_out));
    __asm__("add t5, %0, 0;" : : "r"(buf_y_out));
    __asm__("jal ext;");
    __asm__("add %0, t2, 0;" : "=r"(time) :);

    for (int i = 0; i < N_out; i++) {
        printf("x[%d] = %f; ", i, buf_x_out[i]);
        printf("y[%d] = %f;\r\n", i, buf_y_out[i]);
    }

    printf("time = %d\r\n", time);

    printf("\r\n");
    while(1);
}
