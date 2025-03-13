/*
 * main.s
 *
 *  Created on: Mar 6, 2025
 *      Author: Johnathan Min
 */

.syntax unified
.thumb

.global main

#include "palindrome_1b.s"

.data

hello_world_string: .asciz "Hello World"
palindrome_string: .asciz "racecar"

.text

main:

	// Test 1b
	LDR R1, =hello_world_string
	BL palindrome
	LDR R1, =palindrome_string
	BL palindrome
