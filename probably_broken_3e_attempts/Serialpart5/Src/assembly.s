.syntax unified
.thumb

.global main
#include "initialise.s"

.data
.align
incoming_buffer: .space 62               @Allocate space for 62 characters
terminator: .asciz "*"
received_counter: .byte 62               @Counter for number of received characters
sent_counter: .byte 0                    @ Counter for number of forwarded characters
echo_msg: .asciz "ECHOING BACK\r\n"      @Message shown before echoing back

.text
main:
    BL initialise_power                  @Power configuration
    BL enable_peripheral_clocks          @Enable GPIO clocks
    BL initialise_discovery_board        @ Set GPIOE (LEDs) as output
    BL enable_usart1                     @ Set up USART1 for receive (from PC)
    BL enable_uart4                      @Set up UART4 for transmit (to target)

	LDR R5, =terminator					 @Load Terminating character address
    LDRB R5, [R5]						 @Load the value of R5
    LDR R6, =incoming_buffer			 @Create a buffer for storing from interface
	LDR R7, =received_counter			 @Create a MAX_BUFFER
	LDRB R7, [R7]						 @Load the value of R7
	MOV R8, #0x00						 @Receiving counter
	MOV R9, #0x00						 @Transmitting counter

@ Receive the string imported from the interface using USART1
loop_forever:
    LDR R0, =USART1                   	 @Load USART1 base address
    LDR R1, [R0, USART_ISR]              @Load USART1 status register

@ 'AND' the current status with the bit mask that we are interested in
@ NOTE, the ANDS is used so that if the result is '0' the z register flag is set
    TST R1,1 << UART_ORE | 1 << UART_FE
    BNE clear_error


@ 'AND' the current status with the bit mask that we are interested in
@ NOTE, the ANDS is used so that if the result is '0' the z register flag is set
    TST R1,1 << UART_RXNE
    BEQ loop_forever


    LDRB R3, [R0, USART_RDR]          	 @Read received character into R3
    STRB R3, [R6, R8]				  	 @Store received character into the buffer R6
    ADD R8, #1							 @Increment the received counter

    CMP R3, R5                           @ Compare received character with '*' - Terminating character
    BEQ found_terminator                 @ If terminator received, jump to transmit

   	CMP R7,R8                    		 @ Check whether the buffer is exceeded
    BGT no_reset

@Reset and Clearing error function
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


@When it reaches the terminating character,
@assign the transmitting - required number as the received number of character
found_terminator:
    MOV R9,R8
    B tx_uart						    @Move to transmiting

@ The transfer function is used to transfer previously saved data
tx_uart:
    LDR R6,=incoming_buffer			    @Storing buffer
    MOV R4,R9							@Counter to check if it transmit all character or not

tx_loop:
	LDR R0,=UART4						@Load UART4 base address
    LDR R1,[R0, USART_ISR]				@Load UART4 status register
    TST R1,1 << UART_TXE				@Check if ready to transmit
    BEQ tx_loop

    LDRB R5,[R6], #1					@Load the first byte of the buffer to temporary register
    STRB R5,[R0, USART_TDR]				@Load that temporary register to UART
    SUBS R4,#1							@Subtract the number of transmitting character to 1
    BGT tx_loop							@When the counter > 0, keep transmitting

@ Transfer message Success
tx_success_loop:
	LDR R3,=echo_msg
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
