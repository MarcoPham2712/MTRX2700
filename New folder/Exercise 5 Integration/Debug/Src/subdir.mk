################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../Src/Cipher_fixed.s \
../Src/definitions.s \
../Src/initialise.s \
../Src/main.s 

OBJS += \
./Src/Cipher_fixed.o \
./Src/definitions.o \
./Src/initialise.o \
./Src/main.o 

S_DEPS += \
./Src/Cipher_fixed.d \
./Src/definitions.d \
./Src/initialise.d \
./Src/main.d 


# Each subdirectory must supply rules for building sources it contributes
Src/%.o: ../Src/%.s Src/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m4 -g3 -DDEBUG -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"

clean: clean-Src

clean-Src:
	-$(RM) ./Src/Cipher_fixed.d ./Src/Cipher_fixed.o ./Src/definitions.d ./Src/definitions.o ./Src/initialise.d ./Src/initialise.o ./Src/main.d ./Src/main.o

.PHONY: clean-Src

