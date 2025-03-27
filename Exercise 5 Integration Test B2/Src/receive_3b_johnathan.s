.syntax unified
.thumb

#include "definitions.s"

.data
.align

example_incoming_buffer: .space 256
example_incoming_counter: .byte 255
terminator: .byte '*'


.text
receive_main:
	BL enable_power
	BL enable_peripheral_clocks
	BL enable_usart1_uart4_clocks
	BL use_uart4_pin_config
	BL configure_uart4
	BL finalise_uart4_config

	// Setup and call the receive string function
	LDR R0, =UART4
	LDR R1, =example_incoming_buffer
	LDR R2, =example_incoming_counter
	LDRB R2, [R2]
	LDR R3, =terminator
	LDRB R3, [R3]
	PUSH {R0, R1, R2, R3}
	BL receive_string

	// Append a NULL terminator to the end of the used buffer space
	LDR R1, =example_incoming_buffer
	MOV R2, #0
	STRB R2, [R1, R0]

	//B tx_loop

// Takes in 4 arguments from the stack (in order):
//   UART base address
//   Buffer pointer
//	 Buffer length
//   Terminating character
// Polls UART until the buffer on the stack is full or a terminating character is
// reached.
// The terminating character is not read. No null terminator is provided after
// the received bytes.
// R0: UART to use
// R1: USART Interrupt and Status Register
// R2: Recieved byte
// R3: Buffer index
// R4 to R6: Arguments
// Returns the index after the final character read into the buffer
receive_string:
	POP {R0, R4, R5, R6}
	MOV R3, #0

	receive_until_terminator:
		// Check USART Interrupt and Status Register for Overrun and Frame
		// errors and check if RX buffer has changed (Not Equal)
		LDR R1, [R0, USART_ISR]
		TST R1, 1 << USART_ISR_ORE_BIT | 1 << USART_ISR_FE_BIT
		BNE clear_error
		TST R1, 1 << USART_ISR_RXNE_BIT
		BEQ receive_until_terminator


	LDR R7, =0b00001111
	BL set_led_state

		// Load received byte from receive data register and check for terminator
		LDRB R2, [R0, USART_RDR]
		CMP R2, R6
		BEQ terminator_reached

		// Store byte in buffer and increment pointer
		STRB R2, [R4, R3]
		ADD R3, #1

		// Check that buffer is not full and continue loop
		CMP R3, R5
		BGE buffer_full
		B receive_until_terminator

	terminator_reached:
		ADD R3, #1
		MOV R0, R3
		BX LR

	buffer_full:
		MOV R0, R3
		BX LR

	// Clear the overrun/frame error flags using the Interrupt Clear Flag Register
	clear_error:
   		LDR R1, [R0, USART_ICR]
    	ORR R1, 1 << USART_ICR_ORECF_BIT | 1 << USART_ICR_FECF_BIT
    	STR R1, [R0, USART_ICR]
    	B receive_until_terminator
