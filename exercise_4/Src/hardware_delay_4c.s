.syntax unified
.thumb
#include "initialise.s"
.text

delay_4c:
@ The initialization Settings enable and initialize some of the functions on the STM32 board
    BL enable_timer2_clock        	@ Initializes and enables the TIM2
    BL enable_peripheral_clocks   	@ Initializes and peripheral clocks
    BL initialise_discovery_board 	@ Initialize the board

@ To determine the appropriate prescaler value for setting the counter period
	LDR R0, =TIM2	              	@ Load the base address for the timer
	MOV R1, #0x07                 	@ Setting and putting a prescaler value 7 in R1
	STR R1, [R0, TIM_PSC]         	@ Set the prescaler register

@ Setting the trigger_prescaler function
	BL trigger_prescaler_partc

@ Main logic function
    BL enable_arpe
    BL delayfunction
    BL LED_on
    BL delayfunction
    BL LED_off

@ Set the LEDon function
LED_on:
    LDR R4, =0b11111111           	@ Load bitmask value into R4 and turn on all LEDs
    LDR R0, =GPIOE                	@ Load the address of the GPIOE register into R0
    STR R4, [R0, #ODR + 1]        	@ Store this to the second byte of the ODR (bits 8-15)
    BL delayfunction              	@ Return to the delayfunction
	B LED_off

@ Set the LEDoff function
LED_off:
    LDR R4, =0b00000000           	@ Load bitmask value into R4 and turn off all LEDs
    LDR R0, =GPIOE                	@ Load the address of the GPIOE register into R0
    STR R4, [R0, #ODR + 1]        	@ Store this to the second byte of the ODR (bits 8-15)
    BL delayfunction              	@ Return to the delayfunction
	B LED_on

@ Delay equation
delayfunction:
    LDR R0, =TIM2                 	@ Loads the base address of the Timer2 to R0
wait_loop:
    LDR R1, [R0, #TIM_SR]         	@ Load the Timer 2 Status Register (TIM_SR) into R1
    TST R1, #1                    	@ Test if the Update Interrupt Flag (UIF) is set
    BEQ wait_loop                 	@ Continue to wait
    MOV R2, #0                    	@ Clear the value of the UIF flag
    STR R2, [R0, #TIM_SR]
    BX LR

