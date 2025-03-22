.syntax unified
.thumb
.global main
#include "initialise.s"
.data
.align

incoming_buffer: .space 62
incoming_counter: .byte 62

terminator: .asciz "*"
success_msg: .asciz "successful\n"

.text
receive_main:
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

    LDRB R3,[R0,USART_RDR]      	@ load the lowest byte (RDR bits [0:7] for an 8 bit read)
    STRB R3,[R6,R8]             	@ Store in the buffer
    ADD R8,#1

	LDR R4,=terminator
	LDRB R5,[R4]
	CMP R3,R5              			@ Check whether it is the terminator
    BEQ found_terminator

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





