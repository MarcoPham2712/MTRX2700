.syntax unified
.thumb

#include "definitions.s"


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


