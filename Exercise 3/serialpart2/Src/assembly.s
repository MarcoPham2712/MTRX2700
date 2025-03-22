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
tx_string: .asciz "TEST\r\n"
@Define a custom terminator character
terminator: .byte '*'
@Define max buffer
MAX_BUFFER .byte 61



.text
@ define text


@ this is the entry function called from the c file
main:

	BL initialise_power
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


program_loop:
	BL uart_receive_string          @ Call UART receive function
    B program_loop                  @ Repeat forever

    BX LR                           @ Return

uart_receive_string:
    PUSH {LR}                       @ Save return address

receive_loop:
    BL uart_receive_char        	@Call function to receive one character
    LDRB R4, =terminator        	@Load the user-defined terminating character ('*')
    CMP R2, R4                  	@Compare received char with terminator
    BEQ receive_done            	@If it matches, the done reveiving

    STRB R2, [R6, R7]           	@Store received character in buffer
    ADD R7, R8, #1              	@Increment buffer index
    CMP R7, #61                 	@Ensure buffer does not overflow
    BGE receive_done            	@if exceeded, it will stop receiving

    B receive_loop              	@Repeat for next character

receive_done:
    STRB R4, [R6, R7]				@Store the terminating character at the end

    POP {LR}                        @ Restore return address
    BX LR                           @ Return

uart_receive_char:					@rx_uart
    PUSH {LR}                       @Save return address

wait_for_rx_ready:
    LDR R3, =UART                   @Load UART base address
    LDR R4, [R3, USART_ISR]         @Load UART status register
    TST R4, 1 << UART_RXNE          @Check if Receive buffer is empty
    BL delay_loop                   @DELAY
    BEQ wait_for_rx_ready           @Wait if buffer is full

    LDRB R2, [R3, USART_RDR]        @LOAD character in Receive Data Register

    POP {LR}                        @Restore return address
    BX LR                           @Return

delay_loop:
    LDR R9, =0xFFFFF
delay_inner:
    SUBS R9, #1
    BLT delay_inner
    BX LR
