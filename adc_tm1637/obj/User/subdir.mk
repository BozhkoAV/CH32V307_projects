################################################################################
# MRS Version: {"version":"1.8.5","date":"2023/05/22"}
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../User/TM1637.c \
../User/ch32v30x_it.c \
../User/gpio.c \
../User/main.c \
../User/system_ch32v30x.c 

OBJS += \
./User/TM1637.o \
./User/ch32v30x_it.o \
./User/gpio.o \
./User/main.o \
./User/system_ch32v30x.o 

C_DEPS += \
./User/TM1637.d \
./User/ch32v30x_it.d \
./User/gpio.d \
./User/main.d \
./User/system_ch32v30x.d 


# Each subdirectory must supply rules for building sources it contributes
User/%.o: ../User/%.c
	@	@	riscv-none-embed-gcc -march=rv32imacxw -mabi=ilp32 -msmall-data-limit=8 -msave-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common -Wunused -Wuninitialized  -g -I"C:\code\adc_tm1637\Debug" -I"C:\code\adc_tm1637\Core" -I"C:\code\adc_tm1637\User" -I"C:\code\adc_tm1637\Peripheral\inc" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@

