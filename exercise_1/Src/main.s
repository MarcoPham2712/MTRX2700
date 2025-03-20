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

.text

main:
	// Test 1a
	B case_converter

	// Test 1b
	LDR R1, =hello_world_string
	BL palindrome

	LDR R1, =palindrome_string
	BL palindrome

	// Test 1c
	BL start_caesar_cipher
