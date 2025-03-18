.syntax unified
.thumb
#include "initialise.s"
.global main
.data
@ Define variables
.text

main:
@ The initialization Settings enable and initialize some of the functions on the STM32 board
    BL enable_timer2_clock        	@ Initializes and enables the TIM2
    BL enable_peripheral_clocks   	@ Initializes and peripheral clocks
    BL initialise_discovery_board 	@ Initialize the board

@ Start the counter running
	LDR R0, =TIM2	              	@ Load the base address for the timer
	MOV R1, #0b1                  	@ Store a 1 in bit zero for the CEN flag
	STR R1, [R0, TIM_CR1]         	@ Enable the timer

@ To determine the appropriate prescaler value for setting the counter period, we need to adjust the
@ timer's counting frequency.In the STM32 system, the initial clock frequency is 8 MHz.
@ The counter clock frequency can be calculated using the formula:counter clock frequency =8MHz/(1+prescale).
@ In this case, the required delay period is 0.1 ms. To achieve this, we set the prescaler value to 799,
@ resulting in a counter clock frequency of 10 kHz. Using the formula T=1/f,we can get 1/10kHz = 0.1ms
	LDR R0, =TIM2	              	@ Load the base address for the timer
	MOV R1, #0x31F                 	@ Setting and putting a prescaler value 799 in R1
	STR R1, [R0, TIM_PSC]         	@ Set the prescaler register

@ Setting the trigger_prescaler function
	BL trigger_prescaler

@ The main loop logic of the delay equation operates as follows: first, the system
@ sets the delay parameters, then executes the delay. When the system detects the
@ specified delay time, it triggers the LED control. The LED's blinking frequency
@ serves as an indicator of whether the delay function is working correctly.
Delay_Loop_Function:
    BL Delay_Parameter_Setting_function
    BL LED_on
    BL Delay_Parameter_Setting_function
    BL LED_off

@ Set delay function
Delay_Parameter_Setting_function:
    LDR R1, =10000              	@ Load delay value into R1,Set the delay time to 1s
    LDR R0, =TIM2
    MOV R2, #0
    STR R2, [R0,TIM_CNT]          	@ Reset TIM2 counter to 0

@ Loop comparison checks the delay time.
Delay_Function:
    LDR R3, [R0,TIM_CNT]          	@ Load current value of TIM2 counter into R3
    CMP R3, R1                    	@ Compare the delay value
    BCC Delay_Function            	@ When the current value < Delay value,return to Delay_Function and wait
    BX LR

@Set the LEDon function
LED_on:
    LDR R4, =0xFF           	  	@ Turn on all LEDs
    LDR R0, =GPIOE
    STR R4, [R0,#ODR + 1]
    BL Delay_Parameter_Setting_function
	B LED_off                     	@ Jump to the LED_off function

@Set the LEDoff function
LED_off:
    MOV R4, #0          		  	@ Turn off all LEDs
    LDR R0, =GPIOE
    STR R4, [R0,#ODR + 1]
    BL Delay_Parameter_Setting_function
	B LED_on                      	@ Jump to the LED_on function

