################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../Src/definitions.s \
../Src/echo_3d.s \
../Src/initialise.s \
../Src/main.s \
../Src/receive_3b.s \
../Src/receive_3b_johnathan.s \
../Src/receive_3b_marco.s \
../Src/transmit_3a.s 

OBJS += \
./Src/definitions.o \
./Src/echo_3d.o \
./Src/initialise.o \
./Src/main.o \
./Src/receive_3b.o \
./Src/receive_3b_johnathan.o \
./Src/receive_3b_marco.o \
./Src/transmit_3a.o 

S_DEPS += \
./Src/definitions.d \
./Src/echo_3d.d \
./Src/initialise.d \
./Src/main.d \
./Src/receive_3b.d \
./Src/receive_3b_johnathan.d \
./Src/receive_3b_marco.d \
./Src/transmit_3a.d 


# Each subdirectory must supply rules for building sources it contributes
Src/%.o: ../Src/%.s Src/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m4 -g3 -DDEBUG -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"

clean: clean-Src

clean-Src:
	-$(RM) ./Src/definitions.d ./Src/definitions.o ./Src/echo_3d.d ./Src/echo_3d.o ./Src/initialise.d ./Src/initialise.o ./Src/main.d ./Src/main.o ./Src/receive_3b.d ./Src/receive_3b.o ./Src/receive_3b_johnathan.d ./Src/receive_3b_johnathan.o ./Src/receive_3b_marco.d ./Src/receive_3b_marco.o ./Src/transmit_3a.d ./Src/transmit_3a.o

.PHONY: clean-Src

