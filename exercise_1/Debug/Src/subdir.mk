################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../Src/case_converter_1a.s \
../Src/cipher_1c.s \
../Src/main.s \
../Src/palindrome_1b.s \
../Src/palindrome_1b_extra_cases.s 

OBJS += \
./Src/case_converter_1a.o \
./Src/cipher_1c.o \
./Src/main.o \
./Src/palindrome_1b.o \
./Src/palindrome_1b_extra_cases.o 

S_DEPS += \
./Src/case_converter_1a.d \
./Src/cipher_1c.d \
./Src/main.d \
./Src/palindrome_1b.d \
./Src/palindrome_1b_extra_cases.d 


# Each subdirectory must supply rules for building sources it contributes
Src/%.o: ../Src/%.s Src/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m4 -g3 -DDEBUG -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"

clean: clean-Src

clean-Src:
	-$(RM) ./Src/case_converter_1a.d ./Src/case_converter_1a.o ./Src/cipher_1c.d ./Src/cipher_1c.o ./Src/main.d ./Src/main.o ./Src/palindrome_1b.d ./Src/palindrome_1b.o ./Src/palindrome_1b_extra_cases.d ./Src/palindrome_1b_extra_cases.o

.PHONY: clean-Src

