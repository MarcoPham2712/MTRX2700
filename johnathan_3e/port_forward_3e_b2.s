.syntax unified
.thumb

#include "definitions.s"
#include "initialise.s"
#include "receive_3b_johnathan.s"

.data
.align

receive_buffer: .space 256
receive_length: .byte 255

terminator: .byte '*'

.text
port_forward_b2:
	// Initialise
	BL enable_power
	BL enable_peripheral_clocks
	BL enable_usart1_uart4_clocks
	BL use_uart4_pin_config
	BL configure_uart4
	BL finalise_uart4_config

	// Receive string
	LDR R0, =UART4
	LDR R1, =receive_buffer
	LDR R2, =receive_length
	LDRB R2, [R2]
	LDR R3, terminator
	LDRB R3, [R3]
	PUSH {R0, R1, R2, R3}
	BL receive_string

	// Append NULL terminator
	LDR R1, =receive_buffer
	MOV R2, #0
	STRB R2, [R1, R0]

	finished:
		B finished