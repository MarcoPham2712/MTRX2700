################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../Src/definitions.s \
../Src/initialise.s \
../Src/light_down_leds_2c.s \
../Src/light_up_leds_2b.s \
../Src/main.s \
../Src/set_led_state_2a.s \
../Src/vowels_2d.s 

OBJS += \
./Src/definitions.o \
./Src/initialise.o \
./Src/light_down_leds_2c.o \
./Src/light_up_leds_2b.o \
./Src/main.o \
./Src/set_led_state_2a.o \
./Src/vowels_2d.o 

S_DEPS += \
./Src/definitions.d \
./Src/initialise.d \
./Src/light_down_leds_2c.d \
./Src/light_up_leds_2b.d \
./Src/main.d \
./Src/set_led_state_2a.d \
./Src/vowels_2d.d 


# Each subdirectory must supply rules for building sources it contributes
Src/%.o: ../Src/%.s Src/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m4 -g3 -DDEBUG -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"

clean: clean-Src

clean-Src:
	-$(RM) ./Src/definitions.d ./Src/definitions.o ./Src/initialise.d ./Src/initialise.o ./Src/light_down_leds_2c.d ./Src/light_down_leds_2c.o ./Src/light_up_leds_2b.d ./Src/light_up_leds_2b.o ./Src/main.d ./Src/main.o ./Src/set_led_state_2a.d ./Src/set_led_state_2a.o ./Src/vowels_2d.d ./Src/vowels_2d.o

.PHONY: clean-Src

