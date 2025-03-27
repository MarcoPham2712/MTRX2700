.syntax unified
.thumb

#include "definitions.s"
#include "initialise.s"
#include "receive_3b_johnathan.s"

.data
.align

receive_buffer: .space 256
receive_length: .byte 255

.text

@ initialise the discovery board I/O (just outputs: inputs are selected by default)
Set_LED_to_output:
	LDR R0, =GPIOE 	@ load the address of the GPIOE register into R0
	LDRH R1, [R0, #GPIO_MODER + 2]	@Load the high half-word in the MODER Register
	LDR R2, =0x5555		@Load the binary value of 01 ( OUTPUT ) for each port up to 2 bytes as 0x5555 = 0x0101 0101 0101 0101
	STRH R2, [R0, #GPIO_MODER + 2]	@Store the new register values in the top half word presenting

	BX LR @ return from function call

// Utility functions
set_led_state:
	// Replace GPIOE ODR with R3 bitmask
	LDR R1, =GPIOE
	STRB R3, [R1, #GPIO_ODR + 1]
	BX LR

port_forward_b2:
	// Initialise
	BL enable_power
	BL enable_peripheral_clocks
	BL enable_usart1_uart4_clocks
	BL use_uart4_pin_config
	BL configure_uart4
	BL finalise_uart4_config
	BL Set_LED_to_output

	LDR R3, =0b00000001
	BL set_led_state


	// Receive string
	LDR R0, =UART4
	LDR R1, =receive_buffer
	LDR R2, =receive_length
	LDRB R2, [R2]
	LDR R3, =terminator
	LDRB R3, [R3]
	PUSH {R0, R1, R2, R3}
	BL receive_string

	// Append NULL terminator
	LDR R1, =receive_buffer
	MOV R2, #0
	STRB R2, [R1, R0]

	LDR R3, =0b11111111
	BL set_led_state

	finished:
		B finished
