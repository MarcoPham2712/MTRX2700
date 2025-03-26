.syntax unified
.thumb

#include "definitions.s"
#include "initialise.s"

#include "transmit_3a_johnathan.s"

.data
.align

hello_world_string: .asciz "Hello world!"
hello_world_length: .byte 12

terminator: .byte '*'

.text
port_forward_b1:
	// Initialise
	BL enable_power
	BL enable_peripheral_clocks
	BL enable_usart1_uart4_clocks
	BL use_uart4_pin_config
	BL configure_uart4
	BL finalise_uart4_config

	// Transmit string
	LDR R0, =UART4
	LDR R1, =hello_world_string
	LDR R2, =hello_world_length
	LDRB R2, [R2]
	LDR R3, terminator
	LDRB R3, [R3]
	PUSH {R0, R1, R2, R3}
	BL transmit_string

	finished:
		B finished