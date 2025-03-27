.syntax unified
.thumb
.global main
#include "initialise.s"
.data
.align

incoming_buffer: .space 62
incoming_counter: .byte 62

tx_string: .asciz "TEST\r\n"
terminator: .asciz "*"

.text
@ The initialization Settings enable and initialize some of the functions on the STM32 board
main:
    BL initialise_power				@ Power on the STM32 board
    BL enable_peripheral_clocks		@ Initializes and peripheral clocks
    BL initialise_discovery_board	@ Initialize the board
    BL enable_uart					@ Initialize the UART
@ The button press function
button_check_loop:
    LDR R0,=GPIOA
    LDR R1,[R0,#IDR]
    TST R1,#1
    BEQ button_check_loop

tx_loop:
    LDR R0,=UART               @ The base address for the register to set up UART

    LDR R3,=tx_string          @ Load the memory addresses of the buffer and terminating character information
    LDR R4,=terminator

tx_uart:
    LDR R2,[R0,USART_ISR]      @ Load the status of the UART
@ 'AND' the current status with the bit mask that we are interested in
@ NOTE, the ANDS is used so that if the result is '0' the z register flag is set
    ANDS R2,#(1 << UART_TXE)   @ 检查 TXE (Transmit Data Register Empty) 标志位
@ loop back to check status again if the flag indicates there is no byte waiting
    BEQ tx_uart

    LDRB R5,[R3],#1            @ load the next value in the string into the transmit buffer for the specified UAR
    CMP R5,#0                  @ Check whether it is the bull character
    BEQ send_terminator

    STRB R5,[R0,USART_TDR]
    BNE tx_uart
    B button_check_loop

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

delay_loop:
    LDR R9, =0xFFFFF
delay_inner:
    SUBS R9, #1
    BGT delay_inner
    B button_check_loop
