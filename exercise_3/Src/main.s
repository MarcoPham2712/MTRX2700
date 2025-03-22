.syntax unified
.thumb

.global main

#include "definitions.s"
#include "initialise.s"
#include "transmit_3a.s"
#include "receive_3b.s"
// #include "echo_3d.s" // UNCOMMENT LATER

.data
.align
@ can allocate as an array
@incoming_buffer: .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
@ or allocate just as a block of space with this number of bytes
incoming_buffer: .space 62

@ One strategy is to keep a variable that lets you know the size of the buffer.
incoming_counter: .byte 62

@ Define a string
tx_string: .asciz "Walnut is a beautiful cat\r\n"
@ one way to know the length of the string is to just define it as a variable
tx_length: .byte 27

.text
@ define text


@ this is the entry function called from the c file
main:
	BL initialise_power
	@BL change_clock_speed
	BL enable_peripheral_clocks
	BL enable_uart

	@ To read in data, we need to use a memory buffer to store the incoming bytes
	@ Get pointers to the buffer and counter memory areas
	LDR R6, =incoming_buffer
	LDR R7, =incoming_counter

	@ dereference the memory for the maximum buffer size, store it in R7
	LDRB R7, [R7]

	@ Keep a pointer that counts how many bytes have been received
	MOV R8, #0x00

loop_forever:
	// Load USART Interrupt and Status Register (ISR)
	LDR R0, =UART
	LDR R1, [R0, USART_ISR]

	// Clear errors from overrun and receive enable flags
	TST R1, 1 << UART_ORE | 1 << UART_FE
	BNE clear_error

	// Check if the receive buffer has changed (not equal)
	TST R1, 1 << UART_RXNE
	BEQ loop_forever

	// Load byte from receive data register
	LDRB R3, [R0, USART_RDR]

	// Increment bytes read and ensure buffer does not overflow
	ADD R8, #1
	CMP R7, R8
	BGT no_reset
	MOV R8, #0

no_reset:
	// Load USART Request register and perform a Receive Data Flush Request
	LDR R1, [R0, USART_RQR]
	ORR R1, 1 << UART_RXFRQ
	STR R1, [R0, USART_RQR]

	B loop_forever

clear_error:
	@ Clear the overrun/frame error flag in the register USART_ICR (see page 897)
	LDR R1, [R0, USART_ICR]
	ORR R1, 1 << UART_ORECF | 1 << UART_FECF
	STR R1, [R0, USART_ICR]
	B loop_forever
