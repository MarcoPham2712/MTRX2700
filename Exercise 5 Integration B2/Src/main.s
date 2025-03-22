.syntax unified
.thumb
.global main

#include "definitions.s"
#include "initialise.s"
#include "cipher_1c.s"
#include "palindrome_1b.s"
#include "vowels_2d.s"

.data
// Cipher is 3
decipher_key: .word 3
test_string: .asciz "abcde.fghi44jkl,mnopq1"
test_palindrome: .asciz "efffe"
decipher_buffer: .space 32

.text
set_led_state:
	// Replace GPIOE ODR with R3 bitmask
	LDR R1, =GPIOE
	STRB R3, [R1, #ODR + 1]

	BX LR

main:
    // Initialise GPIO registers
	BL enable_peripheral_clocks // Branch with link to set the clocks for the I/O and UART
	BL Set_LED_to_output        // Once the clocks are started, need to initialise the discovery board I/O
	B program_loop

program_loop:
	// Poll until a message is received
	// TODO

	// Load message into R1
	// TODO
	LDR R1, =test_palindrome

	// Check if message is a palindrome
	check_palindrome:
		BL palindrome

		// Decipher palindrome messages (R0 is 1 if palindrome, otherwise 0)
		CMP R0, #0x1
		BEQ decipher

	B display_message_info

decipher:
	// Setup and run cipher
	LDR R0, =decipher_keyMOV
	LDR R0, [R0]
	LDR R2, =decipher_buffer
	LDR R3, =0x00
	BL caesar_cipher
	B display_message_info

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
