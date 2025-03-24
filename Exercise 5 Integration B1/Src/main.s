.syntax unified
.thumb

.global main

#include "definitions.s"
#include "initialise.s"
#include "Cipher_fixed.s"

.data
@ Define variables
string: .asciz "rAcecar\0"
cipher_key: .byte 0x3
string_bufferr: .space 10
@ define variables

.align

incoming_buffer: .space 62
incoming_counter: .byte 62

terminator: .asciz "*"
success_msg: .asciz "successful\n"

.text

main:

	BL initialise_power				@ Power on the STM32 board
	BL enable_peripheral_clocks		@ Initializes and peripheral clocks
	BL initialise_discovery_board	@ Initialize the board
	BL enable_uart					@ Initialize the UART

@ Load the memory addresses of the buffer and counter information
	LDR R6, =incoming_buffer
	LDR R7, =incoming_counter
	LDRB R7, [R7]
	MOV R8, #0x00
	MOV R9, #0x00

loop_forever:
    LDR R0,=UART					@ the base address for the register to set up UART
    LDR R1,[R0, USART_ISR]			@ load the status of the UART

@ 'AND' the current status with the bit mask that we are interested in
@ NOTE, the ANDS is used so that if the result is '0' the z register flag is set
    TST R1,1 << UART_ORE | 1 << UART_FE
    BNE clear_error
@ 'AND' the current status with the bit mask that we are interested in
@ NOTE, the ANDS is used so that if the result is '0' the z register flag is set
    TST R1,1 << UART_RXNE
    BEQ loop_forever

    LDRB R3,[R0,USART_RDR]
    LDR R4,=terminator
	LDRB R5,[R4]
	CMP R3,R5              			@ Check whether it is the terminator
    BEQ found_terminator     	@ load the lowest byte (RDR bits [0:7] for an 8 bit read)
    STRB R3,[R6,R8]             	@ Store in the buffer
    ADD R8,#1
/*
	LDR R4,=terminator
	LDRB R5,[R4]
	CMP R3,R5              			@ Check whether it is the terminator
    BEQ found_terminator
*/
    CMP R7,R8                    	@ Check whether the buffer is exceeded
    BGT no_reset
    MOV R8,#0

no_reset:
    LDR R1, [R0, USART_RQR]
    ORR R1, 1 << UART_RXFRQ
    STR R1, [R0, USART_RQR]

    B loop_forever

clear_error:
    LDR R1, [R0, USART_ICR]
    ORR R1, 1 << UART_ORECF | 1 << UART_FECF
    STR R1, [R0, USART_ICR]
    B loop_forever

@The length of the saved data is used for later saving
found_terminator:
    MOV R9,R8
    PUSH {R6}
    B palindrome
    B tx_loop

@ The transfer function is used to transfer previously saved data
tx_loop:
    LDR R0,=UART
    LDR R3,=incoming_buffer
    MOV R4,R9

tx_uart:
    LDR R1,[R0, USART_ISR]
    TST R1,1 << UART_TXE
    BEQ tx_uart

    LDRB R5,[R3], #1
    STRB R5,[R0, USART_TDR]
    SUBS R4,#1
    BGT tx_uart
    LDR R3,=success_msg

@ Transfer message Success
tx_success_loop:
    LDRB R5,[R3],#1
    CMP R5,#0
    BEQ restart_loop

tx_uart_success:
    LDR R1,[R0, USART_ISR]
    TST R1,1 << UART_TXE
    BEQ tx_uart_success

    STRB R5,[R0, USART_TDR]
    B tx_success_loop

@Empty the counter and wait to return to the next accept and transfer
restart_loop:
    MOV R8, #0
    B loop_forever

delay_loop:
    LDR R9, =0xfffff
delay_inner:
    SUBS R9, #1
    BGT delay_inner
    BX LR


/*
 * Checks if the string in register R1 is a palindrome
 * (same backwards and forwards)
 * R0 is used as a backwards iterating pointer
 * Result is stored in R0 (1 is palindrome, 0 is not)
 */
palindrome:
	// Load the address of the string into R0
	LDR R0,=cipher_key
	LDRB R0, [R0]
	POP {R1}
	PUSH {R0, R1}
	MOV R0, R1

	// Set R0 pointer to end of string
	palindrome_loop_to_null:
		// Load string value into R2 and compare
		LDRB R2, [R0]
		CMP R2, #0x0
		ADD R0, #0x1
		BNE palindrome_loop_to_null

	// Set pointer to before string NULL terminator
	SUB R0, #0x2

	// Iterate pointers R1/R0 forward/backwards respectively until they pass
	palindrome_loop_until_tested:
		// Load and compare both characters
		LDRB R2, [R0]
		LDRB R3, [R1]
		CMP R2, R3
		BEQ continue_palindrome

		palindrome_check_capital:
			ADD R2, #32
			CMP R2, R3
			BEQ continue_palindrome

		palindrome_check_capital2:
			ADD R3, #32
			SUB R2, #32
			CMP R2, R3
			BNE palindrome_fail

		// Iterate pointers until they pass
		continue_palindrome:
			SUB R0, #0x1
			ADD R1, #0x1
			CMP R0, R1
			BGT palindrome_loop_until_tested

	// Set R0 to 1 if string is a palindrome, else 0
	palindrome_pass:
		BL caesar_cipher
		POP {R1}


	palindrome_fail:
		MOV R2, R1
		palindrome_fail_loop:
			LDRB R3, [R2], #1
			CMP R3, 0x00
			BEQ asterisk
			B palindrome_fail_loop

		asterisk:
			SUB R2, #1
        	MOV R0, #'*'
        	STRB R0, [R2], #1     //Store '*' and increment R1
        	MOV R0, #0
        	STRB R0, [R2]         //Store null character again
        	PUSH {R2}

		BX LR




