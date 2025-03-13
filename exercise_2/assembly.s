.syntax unified
.thumb

.global main

#include "definitions.s"
#include "initialise.s"

.data
@ Define variables

.text

@ this is the entry function called from the startup file
main:

	@ Branch with link to set the clocks for the I/O and UART
	BL enable_peripheral_clocks

	@ Once the clocks are started, need to initialise the discovery board I/O
	BL Set_LED_to_output

	BL Set_LED_state



Set_LED_state:
	LDR R0, =GPIOE	@Load the address of the GPIOE register into R0
	LDRB R1, =START @ load a pattern for the set of LEDs (every second one is on)
	STRB R1, [R0, #ODR + 1]

	BX LR





