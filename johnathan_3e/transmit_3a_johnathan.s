.syntax unified
.thumb

#include "definitions.s"

.text
// Takes in 4 arguments from the stack (in order):
//   UART base address
//   Buffer pointer
//	 Buffer length
//   Terminating character
// Repeatedly sends characters through the transmit buffer
// R0: UART to use
// R1: USART Interrupt and Status Register
// R2: Transmitted byte
// R3: Buffer index
// R4 to R6: Arguments
transmit_string:
    POP {R0, R4, R5, R6}
    MOV R3, #0
	LDR R1, [R0, USART_ISR]

	transmit_until_length:
		// Only transmit when Transmit Buffer Empty (TxE)
		ANDS R1, 1 << USART_ISR_TXE_BIT
		BEQ transmit_until_length

		// Transmit next character
		LDRB R2, [R4], #1
		STRB R2, [R0, USART_TDR]

		// Increment index and repeat until length
		ADD R3, #1
		CMP R3, R5
		BGE transmit_until_length

	transmit_terminator:
		// Only transmit when Transmit Buffer Empty (TxE)
		ANDS R1, 1 << USART_ISR_TXE_BIT
		BEQ transmit_terminator

		// Transmit terminator
		STRB R6, [R0, USART_TDR]
	
	BX LR

/*
tx_loop:
	@ the base address for the register to set up UART
	LDR R0, =UART
	@ load the memory addresses of the buffer and length information
	LDR R3, =tx_string
	LDR R4, =tx_length
	@ dereference the length variable
	@ notice how memory address R4 is replaced by the value that was at that memory address
	LDR R4, [R4]

tx_uart:
	LDR R1, [R0, USART_ISR] @ load the status of the UART
	ANDS R1, 1 << UART_TXE  @ 'AND' the current status with the bit mask that we are interested in
						    @ NOTE, the ANDS is used so that if the result is '0' the z register flag is set
	@ loop back to check status again if the flag indicates there is no byte waiting
	BEQ tx_uart
	@ load the next value in the string into the transmit buffer for the specified UART
	LDRB R5, [R3], #1
	STRB R5, [R0, USART_TDR]
	@ note the use of the S on the end of the SUBS, this means that the register flags are set
	@ and this subtraction can be used to make a branch
	SUBS R4, #1
	@ keep looping while there are more characters to send
	BGT tx_uart
	@ make a delay before sending again
	BL delay_loop
	@ loop back to the start
	B tx_loop


@ a very simple delay
@ you will need to find better ways of doing this
delay_loop:
	LDR R9, =0xfffff

delay_inner:
	@ notice the SUB has an S on the end, this means it alters the condition register
	@ and can be used to make a branching decision.
	SUBS R9, #1
	BGT delay_inner
	BX LR @ return from function call

@ sent the terminating character at the end of the string
send_terminator:
    LDRB R5, [R4]
    LDR R2, [R0, USART_ISR]

tx_uart_terminator:
    ANDS R2, #(1 << UART_TXE)
    BEQ tx_uart_terminator
    STRB R5, [R0, USART_TDR]
    BL delay_loop
    B button_check_loop
*/