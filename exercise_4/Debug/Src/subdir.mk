################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../Src/definitions.s \
../Src/delay_4a.s \
../Src/delay_period_demo_4b.s \
../Src/hardware_delay_4c.s \
../Src/initialise.s 

OBJS += \
./Src/definitions.o \
./Src/delay_4a.o \
./Src/delay_period_demo_4b.o \
./Src/hardware_delay_4c.o \
./Src/initialise.o 

S_DEPS += \
./Src/definitions.d \
./Src/delay_4a.d \
./Src/delay_period_demo_4b.d \
./Src/hardware_delay_4c.d \
./Src/initialise.d 


# Each subdirectory must supply rules for building sources it contributes
Src/%.o: ../Src/%.s Src/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m4 -g3 -DDEBUG -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"

clean: clean-Src

clean-Src:
	-$(RM) ./Src/definitions.d ./Src/definitions.o ./Src/delay_4a.d ./Src/delay_4a.o ./Src/delay_period_demo_4b.d ./Src/delay_period_demo_4b.o ./Src/hardware_delay_4c.d ./Src/hardware_delay_4c.o ./Src/initialise.d ./Src/initialise.o

.PHONY: clean-Src

