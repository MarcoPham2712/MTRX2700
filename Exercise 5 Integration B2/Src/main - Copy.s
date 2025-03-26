.syntax unified
.thumb
.global main

#include "definitions.s"
#include "initialise.s"
#include "cipher_1c.s"
#include "palindrome_1b.s"
#include "receive_3b_johnathan.s"
#include "vowels_2d.s"

.data
// Cipher is 3
decipher_key: .word -3
test_string: .asciz "abcde.fghi44jkl,mnopq1"
test_palindrome: .asciz "efffe"
decipher_buffer: .space 32

serial_buffer: .space 300
serial_buffer_size: .word 300
terminator: .byte '*'

.text
// Utility function
set_led_state:
	// Replace GPIOE ODR with R3 bitmask
	LDR R1, =GPIOE
	STRB R3, [R1, #ODR + 1]
	BX LR

main:
    // Initialise GPIO registers
	BL enable_peripheral_clocks // Branch with link to set the clocks for the I/O and UART
	BL Set_LED_to_output        // Once the clocks are started, need to initialise the discovery board I/O
	// TODO add support for serial via pins
	// TODO add timer initialisation

// It's called a program loop but we never added functionality to reset
// back to here, so in reality its only called once
program_loop:
	// Poll until a message is received
	// Setup and call the receive_string function
	grab_string:
		LDR  R0, =serial_buffer
		LDR  R1, =serial_buffer_size
		LDRB R1, [R1]
		LDR  R2, =terminator
		LDRB R2, [R2]
		PUSH {R0, R1, R2}
		BL receive_string

	// Append a NULL terminator to the end of the used buffer space
	append_null_to_string:
		LDR  R1, =incoming_buffer
		MOV  R2, #0
		STRB R2, [R1, R0]

	// Check if message is a palindrome
	check_palindrome:
		LDR R1, =serial_buffer
		BL palindrome

		// Decipher palindrome messages (R0 is 1 if palindrome, otherwise 0)
		CMP R0, #1
		BEQ decipher
		B display_message_info // Go straight to display if not a palindrome

	decipher:
		// Setup and run cipher
		LDR R0, =decipher_key
		LDR R0, [R0]
		LDR R1, =serial_buffer
		PUSH {R0, R1}
		BL caesar_cipher

	display_message_info:
		// String input for vowels function is R0
		MOV R0, R1

		// Count vowels and consonants in R6 and R7 respectively (from R3, R1 respectively)
		BL Vowels
		MOV R6, R3
		MOV R7, R1

	display_loop:
		// Show vowels count
		MOV R3, R6
		BL set_led_state

		// Delay
		// TODO

		// Show consonants
		MOV R3, R7
		BL set_led_state

		// Delay
		// TODO

		B display_loop
