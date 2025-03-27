################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../Src/definitions.s \
../Src/initialise.s \
../Src/main.s \
../Src/port_forward_3e_b2.s \
../Src/receive_3b_johnathan.s 

OBJS += \
./Src/definitions.o \
./Src/initialise.o \
./Src/main.o \
./Src/port_forward_3e_b2.o \
./Src/receive_3b_johnathan.o 

S_DEPS += \
./Src/definitions.d \
./Src/initialise.d \
./Src/main.d \
./Src/port_forward_3e_b2.d \
./Src/receive_3b_johnathan.d 


# Each subdirectory must supply rules for building sources it contributes
Src/%.o: ../Src/%.s Src/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m4 -g3 -DDEBUG -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"

clean: clean-Src

clean-Src:
	-$(RM) ./Src/definitions.d ./Src/definitions.o ./Src/initialise.d ./Src/initialise.o ./Src/main.d ./Src/main.o ./Src/port_forward_3e_b2.d ./Src/port_forward_3e_b2.o ./Src/receive_3b_johnathan.d ./Src/receive_3b_johnathan.o

.PHONY: clean-Src

