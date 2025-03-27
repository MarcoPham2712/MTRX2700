.syntax unified
.thumb
#include "definitions.s"

.text

delay_4a:
@ Initialize the board TIM and other components.
    BL initialise_system
    B Delay_Loop_Function

@ The initialization Settings enable and initialize some of the functions on the STM32 board
initialise_system:
    PUSH {LR}
    BL enable_peripheral_clocks    @ Initializes peripheral clocks
    BL initialise_discovery_board  @ Initialize the board
    BL enable_timer2_clock         @ Initializes and enables the TIM2

    @ Start the counter running
    LDR R5, =TIM2                  @ Load the base address for the timer
    MOV R6, #0b1                   @ Store a 1 in bit zero for the CEN flag
    STR R6, [R5, TIM_CR1]          @ Enable the timer

    @ Set prescaler to get 0.1ms delay (8MHz / (799+1) = 10kHz)
    MOV R7, #0x07                  @ Prescaler value for demo (should be 799 in full code)
    STR R7, [R5, TIM_PSC]          @ Set the prescaler register

    BL trigger_prescaler
    POP {LR}
    BX LR

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
    LDR R1, =1000000              	@ Load delay value into R1,Set the delay time to 2s
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

