.syntax unified
.thumb

#include "definitions.s"

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
	BL receive_string

	// Append a NULL terminator to the end of the used buffer space
	LDR R1, =incoming_buffer
	MOV R2, #0
	STRB R2, [R1, R0]

	B tx_loop

// Takes in 3 arguments from the stack (in order):
//   Buffer pointer
//	 Buffer length
//   Terminating character
// Polls UART until the buffer on the stack is full or a terminating character is
// reached.
// The terminating character is not read. No null terminator is provided after
// the received bytes.
// R0: UART
// R1: USART Interrupt and Status Register
// R2: Recieved byte
// R3: Buffer index
// R4 to R6: Arguments
// Returns the index after the final character read into the buffer
receive_string:
	POP {R4, R5, R6}
	LDR R0, =UART
	MOV R3, #0

	receive_until_terminator:
		// Check USART Interrupt and Status Register for overrun and frame
		// errors and check if RX buffer has changed (Not Equal)
		LDR R1, [R0, USART_ISR]
		TST R1, 1 << UART_ORE | 1 << UART_FE
		BNE clear_error
		TST R1, 1 << UART_RXNE
		BEQ receive_until_terminator

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
    	ORR R1, 1 << UART_ORECF | 1 << UART_FECF
    	STR R1, [R0, USART_ICR]
    	B receive_until_terminator
