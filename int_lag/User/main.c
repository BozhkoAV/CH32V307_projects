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

    int N_in = 4;
    int N_out = 10;

    float buf_x_in[N_in];
    float buf_y_in[N_in];
    int interval[N_in-1];
    float buf_x_out[N_out];
    float buf_y_out[N_out];

    buf_x_in[0] = 0.0; buf_y_in[0] = 0.0;
    buf_x_in[1] = 2.0; buf_y_in[1] = 4.0;
    buf_x_in[2] = 4.0; buf_y_in[2] = 10.0;
    buf_x_in[3] = 7.0; buf_y_in[3] = 5.0;
    //buf_x_in[4] = 11.0; buf_y_in[4] = 0.0;
    //buf_x_in[5] = 15.0; buf_y_in[5] = 4.0;
    //buf_x_in[6] = 18.0; buf_y_in[6] = 10.0;
    //buf_x_in[7] = 20.0; buf_y_in[7] = 5.0;

    int time;
    TIM6_Init();
    __asm__("add t0, %0, 0;" : : "r"(N_in));
    __asm__("add t1, %0, 0;" : : "r"(buf_x_in));
    __asm__("add t2, %0, 0;" : : "r"(buf_y_in));
    __asm__("add t3, %0, 0;" : : "r"(N_out));
    __asm__("add t4, %0, 0;" : : "r"(buf_x_out));
    __asm__("add t5, %0, 0;" : : "r"(buf_y_out));
    __asm__("add t6, %0, 0;" : : "r"(interval));
    __asm__("jal int_lag;");
    __asm__("add %0, t2, 0;" : "=r"(time) :);

    for (int i = 0; i < N_out; i++) {
        printf("x[%d] = %f; ", i, buf_x_out[i]);
        printf("y[%d] = %f;\r\n", i, buf_y_out[i]);
    }

    printf("time = %d\r\n", time);

    printf("\r\n");
    while(1);
}
