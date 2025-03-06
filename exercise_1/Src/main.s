/*
 * main.s
 *
 *  Created on: Mar 6, 2025
 *      Author: Johnathan Min
 */

.syntax unified
.thumb

.global main

.data

hello_world_string: .asciz "Hello World"
palindrome_string: .asciz "racecar"

.text

main:
