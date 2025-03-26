.syntax unified
.thumb

#include "definitions.s"

.text
entry_2b:
	LDR R4, =0b00000000 @ Clear bitmask
	
program_loop_2b:
	LDR R0, =GPIOE		@Load the address of the GPIOE register into R0
	STRB R4, [R0, #ODR + 1]		@Store this to the second byte of the ODR (bits 8 - 15)

	LDR R0, =GPIOA		@Setup port for input as button
	LDR R1, [R0, IDR]	@Load the byte from input data register to port A

	@Check if button is pressed
	TST R1, #1			@check the state of button
	BEQ program_loop_2b

pressed:
	LDR R1, [R0, IDR]	@Load the byte from input data register to port A
	TST R1, #1			@Check the state of button
	BNE pressed

full_on:
	@Check if all LEDs are on

	CMP R4, #0b11111111	@full-on bitmask
	BEQ reset

turn_on_LED:
	@Increment
	LSL R4, R4, #1		@Left shift by 1
	ORR R4, R4, #1		@Set last bit to 1

	B program_loop_2b	@return to program_loop

reset:
	MOV R4, #0		@Change bitmask to all off
	B program_loop_2b


