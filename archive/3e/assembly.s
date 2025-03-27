.syntax unified
.thumb

.global main
#include "initialise.s"

.data
.align
incoming_buffer: .space 62        @ Allocate space for 62 characters
terminator: .asciz "*"             @ Terminator character to stop receiving
received_counter: .byte 0         @ Counter for number of received characters
sent_counter: .byte 0             @ Counter for number of forwarded characters
echo_msg: .asciz "ECHOING BACK\r\n"  @ Message shown before echoing back

.text
main:
    BL initialise_power                @ Power configuration
    BL enable_peripheral_clocks       @ Enable GPIO clocks
    BL initialise_discovery_board     @ Set GPIOE (LEDs) as output
    BL enable_usart1                  @ Set up USART1 for receive (from PC)
    BL enable_uart4                   @ Set up UART4 for transmit (to target)

    LDR R6, =incoming_buffer          @ Load address of buffer into R6
    MOV R7, #0                        @ R7 = buffer index
    MOV R8, #0                        @ R8 = received character counter
    MOV R9, #0                        @ R9 = forwarded character counter

@--------------------------------------
@ Main loop: Receive, store, forward
@--------------------------------------
loop_forever:
    LDR R0, =USART1                   @ Load USART1 base address
    LDR R1, [R0, USART_ISR]           @ Load USART1 status register
    TST R1, 1 << UART_RXNE            @ Test if a character has been received
    BEQ loop_forever                  @ If not, loop again

    LDRB R2, [R0, USART_RDR]          @ Read received character into R2

    LDR R3, =terminator               @ Load address of terminator character
    LDRB R4, [R3]                     @ Load actual terminator byte into R4
    CMP R2, R4                        @ Compare received character with '*'
    BEQ echo_back                     @ If terminator received, jump to echo

    STRB R2, [R6, R7]                 @ Store R2 into buffer at offset R7
    ADD R7, R7, #1                    @ Increment buffer index
    ADD R8, R8, #1                    @ Increment received counter

    BL forward_char                   @ Send R2 to UART4
    ADD R9, R9, #1                    @ Increment sent counter

    BL delay_loop                     @ Delay for smoother transmission
    B loop_forever                    @ Repeat

@---------------------------------------------------
@ Function: Echo stored message back to USART1
@---------------------------------------------------
echo_back:
    LDR R3, =echo_msg                 @ Load address of echo header string
echo_msg_loop:
    LDRB R5, [R3], #1                 @ Load next byte of message into R5, post-increment
    CMP R5, #0                        @ Check for end of string
    BEQ begin_echo                    @ If null terminator, start echoing buffer

    BL tx_usart1_char                 @ Send char in R5 to USART1
    BL delay_loop                     @ Add delay between characters
    B echo_msg_loop

@---------------------------------------------------
@ Begin echoing actual stored buffer
@---------------------------------------------------
begin_echo:
    LDR R3, =incoming_buffer          @ Load buffer start into R3
    MOV R10, R7                       @ Copy buffer length to R10

echo_loop:
    LDRB R5, [R3], #1                 @ Load next character to echo
    BL tx_usart1_char                 @ Send to USART1
    BL delay_loop                     @ Delay between echoed characters

    SUBS R10, R10, #1                 @ Decrement remaining counter
    BGT echo_loop                     @ If not zero, keep echoing

@---------------------------------------------------
@ Reset counters and return to main loop
@---------------------------------------------------
    MOV R7, #0                        @ Reset buffer index
    MOV R8, #0                        @ Reset received count
    MOV R9, #0                        @ Reset sent count

    B loop_forever                    @ Back to receiving

@---------------------------------------------------
@ Subroutine: Send R2 to UART4
@---------------------------------------------------
forward_char:
    PUSH {LR}                         @ Save return address
    LDR R0, =UART4                    @ Load UART4 base address
wait_uart4:
    LDR R1, [R0, USART_ISR]           @ Load status register
    TST R1, 1 << UART_TXE             @ Check if TX buffer is empty
    BEQ wait_uart4                    @ Wait if not ready
    STRB R2, [R0, USART_TDR]          @ Send byte to UART4
    POP {LR}                          @ Restore return address
    BX LR                             @ Return

@---------------------------------------------------
@ Subroutine: Send R5 to USART1 (echo)
@---------------------------------------------------
tx_usart1_char:
    PUSH {LR}
    LDR R0, =USART1
wait_usart1:
    LDR R1, [R0, USART_ISR]
    TST R1, 1 << UART_TXE
    BEQ wait_usart1
    STRB R5, [R0, USART_TDR]
    POP {LR}
    BX LR

@---------------------------------------------------
@ Subroutine: Basic delay loop
@---------------------------------------------------
delay_loop:
    LDR R12, =0xFFFFF                 @ Load large count
delay_inner:
    SUBS R12, #1                      @ Decrement
    BGT delay_inner                   @ Loop until done
    BX LR
