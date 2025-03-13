.syntax unified
.thumb

.global main

#include "definitions.s"
#include "initialise.s"

.data
@ Define variables
string: .asciz "abcdefghijklmnopqrstuv\0"

.text

@ this is the entry function called from the startup file
main:
	BL enable_peripheral_clocks
	BL Set_LED_to_output
	BL Set_button_input

	LDR R0, =string
	LDR R1, =0b0 //Letters
	LDR R3, =0b0 //vowels
	LDR R5, =0b0 //Switch Vowel/cons


count_letters:
	LDRB R2, [R0], #1    // After loading byte pointer is incremented by 1
    CMP R2, #0           // Check if reached the end of the string
    BEQ continue
    ADD R1, #0b1
    B count_letters

	continue:
    	LDR R0, =string
    	B lowercase

    lowercase:
        LDRB R4, [R0], #1    // After loading byte pointer is incremented by 1
        CMP R4, #0           // Check if reached the end of the string
        BEQ end_lowercase
        CMP R4, #'A'
        BLT lowercase       // If less than 'A', it's not an uppercase letter
        CMP R4, #'Z'
        BGT lowercase       // If greater than 'Z', it's not an uppercase letter
        ADD R4, #32
        SUB R0, #1     // Convert to lowercase by adding 32 (as shown in the ASCII table this converts to lowercase)
        STRB R4, [R0]   // Store the modified character at the point it was found
        B lowercase

	end_lowercase:
		LDR R0, =string
    	B count_vowels

    count_vowels:
    	LDRB R2, [R0], #1
    	CMP R2, 'e'
    	BEQ add_vowel
    	CMP R2, 'i'
    	BEQ add_vowel
    	CMP R2, 'o'
    	BEQ add_vowel
    	CMP R2, 'u'
    	BEQ add_vowel
    	CMP R2, 'a'
    	BEQ add_vowel
    	CMP R2, #0
    	BEQ end
    	B count_vowels

    add_vowel:
    	ADD R3, #0b1
    	B count_vowels
    end:
    	SUB R1, R3
    	B Set_Vowel_LED

    button_press:
	LDR R0, = GPIOA
	LDRB R4, [R0, #IDR]
	TST R4, #0x01
	BEQ button_press

	wait:
	LDR R4, [R0, #IDR]
	TST R4, #0x1
	BNE wait

	toggle:
	EOR R5, #0b1
	CMP R5, #0b0
	BEQ Set_Vowel_LED
	CMP R5, #0b1
	BEQ Set_Cons_LED

    Set_Vowel_LED:
	LDR R0, =GPIOE	@Load the address of the GPIOE register into R0
	STRB R3, [R0, #ODR + 1]
	B button_press

	Set_Cons_LED:
	LDR R0, =GPIOE	@Load the address of the GPIOE register into R0
	STRB R1, [R0, #ODR + 1]
	B button_press




