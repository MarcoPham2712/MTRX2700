.syntax unified
.thumb

#include "definitions.s"
.text
@ Define code
enable_timer2_clock:

	LDR R0, =RCC	             @ Load the base address for the timer
	LDR R1, [R0, APB1ENR] 	     @ Load the peripheral clock control register
	ORR R1, 1 << TIM2EN          @ Store a 1 in bit for the TIM2 enable flag
	STR R1, [R0, APB1ENR]        @ Enable the timer
	BX LR                        @ Return
@ Function to enable the clocks for the peripherals we are using (A, C and E)
enable_peripheral_clocks:
	LDR R0, =RCC                 @ Load the address of the RCC address boundary (for enabling the IO clock)
	LDR R1, [R0, #AHBENR]        @ Load the current value of the peripheral clock registers
	ORR R1, 1 << 21 | 1 << 19 | 1 << 17  @ 21st bit is enable GPIOE clock, 19 is GPIOC, 17 is GPIOA clock
	STR R1, [R0, #AHBENR]        @ Store the modified register back to the submodule
	BX LR                        @ Return
@ Initialise the discovery board I/O (just outputs: inputs are selected by default)
initialise_discovery_board:
	LDR R0, =GPIOE 	             @ Load the address of the GPIOE register into R0
	LDR R1, =0x5555              @ Load the binary value of 01 (OUTPUT) for each port in the upper two bytes
					             @ As 0x5555 = 01010101 01010101
	STRH R1, [R0, #MODER + 2]    @ Store the new register values in the top half word representing
								 @ The MODER settings for pe8-15
	BX LR                        @ Return from function call
trigger_prescaler:
@ Use (TIMx_EGR) instead (to reset the clock)
@ This is a hack to get the prescaler to take affect
@ the prescaler is not changed until the counter overflows
@ the TIMx_ARR register sets the count at which the overflow
@ happens. Here, the reset is triggered and the overflow
@ occurs to make the prescaler take effect.
@ you should use a different approach to this !
@ In your code, you should be using the ARR register to
@ set the maximum count for the timer
@ store a value for the prescaler
	LDR R0, =TIM2	             @ Load the base address for the timer
	LDR R1, =0x1                 @ Make the timer overflow after counting to only 1
	STR R1, [R0, TIM_ARR]        @ Set the ARR register
	LDR R8, =0x00
	STR R8, [R0, TIM_CNT]        @ Reset the clock
	NOP
	NOP
	LDR R1, =0xffffffff          @ Set the ARR back to the default value
	STR R1, [R0, TIM_ARR]        @ Set the ARR register
	BX LR
trigger_prescaler_partc:
@ Use (TIMx_EGR) instead (to reset the clock)
@ This is a hack to get the prescaler to take affect
@ the prescaler is not changed until the counter overflows
@ the TIMx_ARR register sets the count at which the overflow
@ happens. Here, the reset is triggered and the overflow
@ occurs to make the prescaler take effect.
@ you should use a different approach to this !
@ In your code, you should be using the ARR register to
@ set the maximum count for the timer
@ store a value for the prescaler
	LDR R0, =TIM2	             @ Load the base address for the timer
	LDR R1, =1000000             @ Make the timer overflow after counting to only 1
	STR R1, [R0, TIM_ARR]        @ Set the ARR register
	LDR R8, =0x00
	STR R8, [R0, TIM_CNT]        @ Reset the clock
	NOP
	NOP
	BX LR

@ The setting of ARPE ensures that the value of ARR can be counted reasonably.
@ Prevent the cycle from not completing due to the second rewrite ARR and start a new timer directly.
enable_arpe:
    LDR R0, =TIM2
    LDR R1, [R0, #TIM_CR1]
    ORR R1, R1, #(1 << 7 | 1 << 0)  @ bit7: ARPE, bit0: CEN
    STR R1, [R0, #TIM_CR1]
    BX LR

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

