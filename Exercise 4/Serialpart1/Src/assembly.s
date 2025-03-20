.syntax unified
.thumb

.global main

#include "initialise.s"

.data
@ define variables


.align
@ can allocate as an array
@incoming_buffer: .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
@ or allocate just as a block of space with this number of bytes
incoming_buffer: .space 62
@ One strategy is to keep a variable that lets you know the size of the buffer.
incoming_counter: .byte 62

@ Define a string
tx_string: .asciz "TEST\r\n*"
@Define a custom terminator character
terminator: .asciz "*"



.text
@ define text


@ this is the entry function called from the c file
main:

	BL initialise_power
	BL enable_peripheral_clocks
	BL enable_uart


program_loop:
	BL button_check_loop   		   	@ Check if button is pressed and send message
    B program_loop                 	@ Repeat forever

button_check_loop:
	LDR R0, =GPIOA                  @ Load GPIOA base address
    LDR R1, [R0, IDR]        		@ Load GPIO mode register
    TST R1, #1        				@ Check if PA0 (User Button) is pressed
    BEQ button_check_loop           @ If not pressed, keep checking


    LDR R1, =tx_string              @ Load address of the message string
    LDR R7, =terminator
    LDR R7, [R7]
    BL uart_transmit_string         @ Call UART transmit function

    BX LR                           @ Return


uart_transmit_string:
    PUSH {LR}                       @ Save return address

transmit_loop:						@tx_loop
    LDRB R2, [R1], #1               @ Load a byte from the string and increment pointer
    CMP R2, R7                   	@ Check if null terminator reached
    BEQ transmit_done               @ If null, end transmission

    BL uart_transmit_char           @ Send character via UART
    B transmit_loop                 @ Continue sending characters

transmit_done:
    B program_loop           		@ Send the terminating character

    POP {LR}                        @ Restore return address
    BX LR                           @ Return

uart_transmit_char:					@tx_uart
    PUSH {LR}                       @ Save return address

wait_for_tx_ready:
    LDR R3, =UART                   @ Load UART base address
    LDR R4, [R3, USART_ISR]         @ Load UART status register
    TST R4, 1 << UART_TXE           @ Check if Transmit buffer is empty
    BL delay_loop
    BEQ wait_for_tx_ready           @ Wait if buffer is full

    STRB R2, [R3, USART_TDR]        @ Store character in Transmit Data Register

    POP {LR}                        @ Restore return address
    BX LR                           @ Return

delay_loop:
    LDR R9, =0xFFFFF
delay_inner:
    SUBS R9, #1
    BLT delay_inner
    BX LR
