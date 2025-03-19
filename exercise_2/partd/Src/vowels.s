.syntax unified
.thumb

.global main

#include "definitions.s"
#include "initialise.s"

.data

string: .asciz "abcde.fghi44jkl,mnopq1\0"

.text


Vowels:
	BL enable_peripheral_clocks
	BL Set_LED_to_output
	BL Set_button_input

	LDR R0, =string
	LDR R1, =0b0 //Count Letters
	LDR R3, =0b0 //Count vowels
	LDR R5, =0b0 //Switch Vowel/Cons


count_letters:
	LDRB R2, [R0], #1    // After loading byte pointer is incremented by 1
    CMP R2, #0           // Check if reached the end of the string
    BEQ continue
	B Checkif_letter

Checkif_letter:
//If character is less than 'A' it is not a letter
	CMP   R2, #'A'
    BLT count_letters
//If character is greater than 'Z' could not be a letter
    CMP   R2, #'Z'
    BGT Check_lowercase

Check_lowercase:
//If character is less than 'a' and greater than 'Z' it is not a letter
	CMP R2, #'a'
	BLT count_letters
//If character is greater than 'z' it is not a letter
	CMP R2, #'z'
	BGT count_letters
	B Add_letter

Add_letter:
	ADD R1, #0b1        // Add 1 to the letters counter
	B count_letters

	continue:
    	LDR R0, =string // Reload the string from the start
    	B lowercase

    lowercase:
        LDRB R4, [R0], #1    // After loading byte pointer is incremented by 1
        CMP R4, #0           // Check if reached the end of the string
        BEQ end_lowercase
       // If less than 'A', it's not an uppercase letter
        CMP R4, #'A'
        BLT lowercase
        // If greater than 'Z', it's not an uppercase letter
        CMP R4, #'Z'
        BGT lowercase
        ADD R4, #32		// Convert to lowercase by adding 32 (as shown in the ASCII table this converts to lowercase)
        SUB R0, #1
        STRB R4, [R0]   // Store the modified character at the point it was found
        B lowercase

	end_lowercase:
		LDR R0, =string //Reload the string from the start
    	B count_vowels

    count_vowels:
    	LDRB R2, [R0], #1	// After loading byte pointer is incremented by 1
    	//Check if the loaded byte is equal to a vowel, if so add 1 to R3 (vowel counter)
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
    	//Loop until end of the string (null terminator)
    	CMP R2, #0
    	BEQ end
    	B count_vowels

    add_vowel:
    	ADD R3, #0b1
    	B count_vowels
    end:
    	//Subtract vowles from letters to get consonants count
    	SUB R1, R3
    	//Set vowel LEDs first
    	B Set_Vowel_LED

	//When button is pressed wait for it to be released before changing LEDs
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
	//When button is pressed toggle R5 to register either showing Vowels or Consonants
	EOR R5, #0b1
	CMP R5, #0b0
	BEQ Set_Vowel_LED
	CMP R5, #0b1
	BEQ Set_Cons_LED

    Set_Vowel_LED:
	LDR R0, =GPIOE	//Load the address of the GPIOE register into R0
	STRB R3, [R0, #ODR + 1] //store the binary count of vowles in the LED output
	B button_press

	Set_Cons_LED:
	LDR R0, =GPIOE	//Load the address of the GPIOE register into R0
	STRB R1, [R0, #ODR + 1] //Store the binary count of consonants in the LED output
	B button_press




