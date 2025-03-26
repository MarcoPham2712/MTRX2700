.syntax unified
.thumb

#include "initialise.s"

.data
.align
incoming_buffer: .space 62
incoming_counter: .byte 62

tx_string: .asciz "TEST\r\n"
terminator: .asciz "*"

.text
transmit_main:
	BL enable_power
	BL enable_peripheral_clocks
	BL enable_usart1_uart4_clocks
	BL use_uart4_pin_config
	BL configure_uart4
	BL finalise_uart4_config
    
button_check_loop:
    LDR R0,=GPIOA
    LDR R1,[R0,#IDR]
    TST R1,#1
    BEQ button_check_loop

// Takes in 4 arguments from the stack (in order):
//   UART base address
//   Buffer pointer
//	 Buffer length
//   Terminating character
transmit_string:
    POP {R0, R4, R5, R6}
    MOV R3, #0

    LDR R0,=UART               @ The base address for the register to set up UART
    LDR R3,=tx_string          @ Load the memory addresses of the buffer and terminating character information
    LDR R4,=terminator

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
