.syntax unified
.thumb

#include "definitions.s"

.text
Set_LED_state:
	LDR R0, =GPIOE	            @ Load the address of the GPIOE register into R0
	LDRB R1, =START 		    @ load a pattern for the set of LEDs (every second one is on)
	STRB R1, [R0, #ODR + 1]     @ ODR GPIO Output register

	BX LR
