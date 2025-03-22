################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../Src/cipher_1c.s \
../Src/definitions.s \
../Src/initialise.s \
../Src/main.s \
../Src/palindrome_1b.s \
../Src/vowels_2d.s 

OBJS += \
./Src/cipher_1c.o \
./Src/definitions.o \
./Src/initialise.o \
./Src/main.o \
./Src/palindrome_1b.o \
./Src/vowels_2d.o 

S_DEPS += \
./Src/cipher_1c.d \
./Src/definitions.d \
./Src/initialise.d \
./Src/main.d \
./Src/palindrome_1b.d \
./Src/vowels_2d.d 


# Each subdirectory must supply rules for building sources it contributes
Src/%.o: ../Src/%.s Src/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m4 -g3 -DDEBUG -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"

clean: clean-Src

clean-Src:
	-$(RM) ./Src/cipher_1c.d ./Src/cipher_1c.o ./Src/definitions.d ./Src/definitions.o ./Src/initialise.d ./Src/initialise.o ./Src/main.d ./Src/main.o ./Src/palindrome_1b.d ./Src/palindrome_1b.o ./Src/vowels_2d.d ./Src/vowels_2d.o

.PHONY: clean-Src

