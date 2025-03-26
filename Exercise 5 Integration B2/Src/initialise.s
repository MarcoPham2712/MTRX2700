.syntax unified
.thumb

#include "definitions.s"

enable_timer2_clock:
	LDR R0, =RCC	             @ Load the base address for the timer
	LDR R1, [R0, APB1ENR] 	     @ Load the peripheral clock control register
	ORR R1, 1 << TIM2EN          @ Store a 1 in bit for the TIM2 enable flag
	STR R1, [R0, APB1ENR]        @ Enable the timer
	BX LR                        @ Return
@ Function to enable the clocks for the peripherals we are using (A, C and E)
timer_enable_peripheral_clocks:
	LDR R0, =RCC                 @ Load the address of the RCC address boundary (for enabling the IO clock)
	LDR R1, [R0, #AHBENR]        @ Load the current value of the peripheral clock registers
	ORR R1, 1 << 21 | 1 << 19 | 1 << 17  @ 21st bit is enable GPIOE clock, 19 is GPIOC, 17 is GPIOA clock
	STR R1, [R0, #AHBENR]        @ Store the modified register back to the submodule
	BX LR                        @ Return
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
	LDR R1, =10000000             @ Make the timer overflow after counting to only 1
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
@ initialise the power systems on the microcontroller
@ PWREN (enable power to the clock), SYSCFGEN system clock enable
initialise_power:
	LDR R0, =RCC @ the base address for the register to turn clocks on/off
	@ enable clock power in APB1ENR
	LDR R1, [R0, #APB1ENR]
	ORR R1, 1 << PWREN @ apply the bit mask for power enable
	STR R1, [R0, #APB1ENR]
	@ enable clock config in APB2ENR
	LDR R1, [R0, #APB2ENR]
	ORR R1, 1 << SYSCFGEN @ apply the bit mask to allow clock configuration
	STR R1, [R0, #APB2ENR]
	BX LR @ return


@ function to enable a UART device - this requires:
@  setting the alternate pin functions for the UART (select the pins you want to use)
@
@ BAUD rate needs to change depending on whether it is 8MHz (external clock) or 24MHz (our PLL setting)
enable_uart:
	@make a note about the different ways that we set specific bits in this configuration section
	@ select which UART you want to enable
	LDR R0, =GPIOC
	@ set the alternate function for the UART pins (what ever you have selected)
	LDR R1, =0x77
	STRB R1, [R0, AFRL + 2]
	@ modify the mode of the GPIO pins you want to use to enable 'alternate function mode'
	LDR R1, [R0, GPIO_MODER]
	ORR R1, 0xA00 @ Mask for pins to change to 'alternate function mode'
	STR R1, [R0, GPIO_MODER]
	@ modify the speed of the GPIO pins you want to use to enable 'high speed'
	LDR R1, [R0, GPIO_OSPEEDR]
	ORR R1, 0xF00 @ Mask for pins to be set as high speed
	STR R1, [R0, GPIO_OSPEEDR]
	@ Set the enable bit for the specific UART you want to use
	@ Note: this might be in APB1ENR or APB2ENR
	@ you can find this out by looking in the datasheet
	LDR R0, =RCC @ the base address for the register to turn clocks on/off
	LDR R1, [R0, #APB2ENR] @ load the original value from the enable register
	ORR R1, 1 << UART_EN  @ apply the bit mask to the previous values of the enable the UART
	STR R1, [R0, #APB2ENR] @ store the modified enable register values back to RCC
	@ this is the baud rate
	MOV R1, #0x46 @ from our earlier calculations (for 8MHz), store this in register R1
	LDR R0, =UART @ the base address for the register to turn clocks on/off
	STRH R1, [R0, #USART_BRR] @ store this value directly in the first half word (16 bits) of
							  	 @ the baud rate register
	@ we want to set a few things here, lets define their bit positions to make it more readable
	LDR R0, =UART @ the base address for the register to set up the specified UART
	LDR R1, [R0, #USART_CR1] @ load the original value from the enable register
	ORR R1, 1 << UART_TE | 1 << UART_RE | 1 << UART_UE @ make a bit mask with a '1' for the bits to enable,
 @ apply the bit mask to the previous values of the enable register
	STR R1, [R0, #USART_CR1] @ store the modified enable register values back to RCC
	BX LR @ return


enable_peripheral_clocks:
	LDR R0, = RCC @ load the address of the RCC address boundary (for enabling the IO clock)
	LDR R1, [R0, #AHBENR]	@ load the current value of the peripheral clock registers
	MOV R2, 1 << GPIOA_ENABLE | 1 << GPIOE_ENABLE	@ 21st bit is enable GPIOE clock, 17 is GPIOA clock
	ORR R1, R2	@Set the values of these two clocks on
	STR R1, [R0, #AHBENR]	@Store the modified register back to the submodule
	BX LR	@return from function call


@ initialise the discovery board I/O (just outputs: inputs are selected by default)
Set_LED_to_output:
	LDR R0, =GPIOE 	@ load the address of the GPIOE register into R0
	LDRH R1, [R0, #MODER + 2]	@Load the high half-word in the MODER Register
	LDR R2, =0x5555		@Load the binary value of 01 ( OUTPUT ) for each port up to 2 bytes as 0x5555 = 0x0101 0101 0101 0101
	STRH R2, [R0, #MODER + 2]	@Store the new register values in the top half word presenting

	BX LR @ return from function call

Set_button_input:
	LDR R0, = GPIOA
	LDRB R1, [R0, #MODER]
	AND R1, #0b11111100
	STRB R1, [R0, #MODER]
	BX LR
