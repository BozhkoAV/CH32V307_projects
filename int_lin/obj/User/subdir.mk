################################################################################
# MRS Version: {"version":"1.8.4","date":"2023/02/015"}
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../User/int_lin.s 

C_SRCS += \
../User/ch32v30x_it.c \
../User/fonts.c \
../User/ili9341.c \
../User/main.c \
../User/spi.c \
../User/system_ch32v30x.c 

OBJS += \
./User/ch32v30x_it.o \
./User/fonts.o \
./User/ili9341.o \
./User/int_lin.o \
./User/main.o \
./User/spi.o \
./User/system_ch32v30x.o 

S_DEPS += \
./User/int_lin.d 

C_DEPS += \
./User/ch32v30x_it.d \
./User/fonts.d \
./User/ili9341.d \
./User/main.d \
./User/spi.d \
./User/system_ch32v30x.d 


# Each subdirectory must supply rules for building sources it contributes
User/%.o: ../User/%.c
	@	@	riscv-none-embed-gcc -march=rv32imafcxw -mabi=ilp32 -msmall-data-limit=8 -msave-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common -Wunused -Wuninitialized  -g -I"C:\code\int_lin\Debug" -I"C:\code\int_lin\Core" -I"C:\code\int_lin\User" -I"C:\code\int_lin\Peripheral\inc" -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@
User/%.o: ../User/%.s
	@	@	riscv-none-embed-gcc -march=rv32imafcxw -mabi=ilp32 -msmall-data-limit=8 -msave-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common -Wunused -Wuninitialized  -g -x assembler-with-cpp -I"C:\code\int_lin\Startup" -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@	@

