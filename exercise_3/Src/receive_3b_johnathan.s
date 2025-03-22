.syntax unified
.thumb
#include "initialise.s"
.data
.align

incoming_buffer: .space 256
incoming_counter: .byte 255

terminator: .byte '*'

.text
receive_main:
	BL initialise_power				@ Power on the STM32 board
	BL enable_peripheral_clocks		@ Initializes and peripheral clocks
	BL initialise_discovery_board	@ Initialize the board
	BL enable_uart					@ Initialize the UART

	// Setup and call the receive string function
	LDR R0, =incoming_buffer
	LDR R1, =incoming_counter
	LDRB R1, [R1]
	LDR R2, =terminator
	LDRB R2, [R2]
	PUSH {R0, R1, R2}
	B receive_string

	// Append a NULL terminator to the end of the used buffer space
	LDR R3, =incoming_buffer
	MOV R4, #0
	STRB R4, [R3, R0]

// Takes in 3 arguments from the stack:
//   Buffer pointer
//	 Buffer length
//   Terminating character
// Polls UART until the buffer on the stack is full or a terminating character is
// reached.
// The terminating character is not read. No null terminator is provided after
// the received bytes.
// Returns the index after the final character read into the buffer
receive_string:
	POP {R6, R7, R4}
	MOV R5, #0

	receive_until_terminator:
		// Load USART Interrupt and Status Register (ISR)
		LDR R0, =UART
		LDR R1, [R0, USART_ISR]

		// Clear errors from overrun and receive enable flags
		TST R1, 1 << UART_ORE | 1 << UART_FE
		BNE clear_error

		// Check if the receive buffer has changed (not equal)
		TST R1, 1 << UART_RXNE
		BEQ receive_until_terminator

		// Load received byte from receive data register
		LDRB R3, [R0, USART_RDR]

		// Check if the terminator is reached
		CMP R3, R4
		BEQ terminator_reached

		// Store byte in buffer and increment pointer
		STRB R3, [R6, R5]
		ADD R5, #1

		// Check that buffer is not full
		CMP R5, R7
		BGE buffer_full

		B receive_until_terminator

	terminator_reached:
		ADD R5, #1
		MOV R0, R5
		BX LR

	buffer_full:
		MOV R0, R5
		BX LR

	// Clear the overrun/frame error flags using the Interrupt flag Clear Register
	clear_error:
   		LDR R1, [R0, USART_ICR]
    	ORR R1, 1 << UART_ORECF | 1 << UART_FECF
    	STR R1, [R0, USART_ICR]
    	B receive_until_terminator
