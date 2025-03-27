/*
 * main.s
 *
 *  Created on: Mar 6, 2025
 *      Author: Johnathan Min
 */

.syntax unified
.thumb

.global main

#include "case_converter_1a.s"
#include "palindrome_1b.s"
#include "cipher_1c.s"

.data

hello_world_string: .asciz "Hello World"
palindrome_string: .asciz ".raceCAR."
converted_hello_world_string: .asciz "                "

// Tested with large positive and negative values
cipher_key: .byte 3
cipher_key_1: .byte -3
cipher_key_2: .byte 27
cipher_key_3: .byte -53

// Tested with non-alphabet characters, uppercase and lower case
cipher_string: .asciz "abc"
cipher_string_1: .asciz "AaZzCc"
cipher_string_2: .asciz "..--Aa"

.text

main:
	// Test 1a
	LDR R0, =0
	LDR R1, =hello_world_string
	LDR R2, =converted_hello_world_string
	B case_converter_run

	// Test 1b
	LDR R1, =hello_world_string
	BL palindrome

	LDR R1, =palindrome_string
	BL palindrome

	// Test 1c
	// Basic test
	LDR R0, =cipher_key
	LDRB R0, [R0]
	LDR R1, =cipher_string
	PUSH {R0, R1}
	BL caesar_cipher

	LDR R1, =cipher_string_1
	PUSH {R0, R1}
	BL caesar_cipher

	LDR R1, =cipher_string_2
	PUSH {R0, R1}
	BL caesar_cipher

	// Negative (Decipher) test
	LDR R0, =cipher_key_1
	LDRSB R0, [R0]
	LDR R1, =cipher_string
	PUSH {R0, R1}
	BL caesar_cipher

	LDR R1, =cipher_string_1
	PUSH {R0, R1}
	BL caesar_cipher

	LDR R1, =cipher_string_2
	PUSH {R0, R1}
	BL caesar_cipher

	// Overflow test
	LDR R0, =cipher_key_2
	LDRSB R0, [R0]
	LDR R1, =cipher_string
	PUSH {R0, R1}
	BL caesar_cipher

	LDR R1, =cipher_string_1
	PUSH {R0, R1}
	BL caesar_cipher

	LDR R1, =cipher_string_2
	PUSH {R0, R1}
	BL caesar_cipher

	// Negative overflow (decipher) test
	LDR R0, =cipher_key_3
	LDRSB R0, [R0]
	LDR R1, =cipher_string
	PUSH {R0, R1}
	BL caesar_cipher

	LDR R1, =cipher_string_1
	PUSH {R0, R1}
	BL caesar_cipher

	LDR R1, =cipher_string_2
	PUSH {R0, R1}
	BL caesar_cipher

program_loop:
	B program_loop
