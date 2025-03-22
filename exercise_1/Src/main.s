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
palindrome_string: .asciz "racecar"

// Tested with large positive and negative values
cipher_key: .byte 27

// Tested with non-alphabet characters, uppercase and lower case
cipher_string: .asciz "abc"
cipher_string_1: .asciz "aaabbbccc"
cipher_string_2: .asciz "aaabbbccc"
cipher_string_3: .asciz "aaabbbccc"

.text

main:
	// Test 1a
	// B case_converter

	// Test 1b
	// LDR R1, =hello_world_string
	// BL palindrome

	// LDR R1, =palindrome_string
	// BL palindrome

	// Test 1c
	LDR R0, =cipher_key
	LDRSB R0, [R0]
	LDR R1, =cipher_string
	PUSH {R0, R1}
	BL caesar_cipher
