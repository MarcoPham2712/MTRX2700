.syntax unified
.thumb

.text
palindrome:
	// Load the address of the string into R1
	MOV R0, R1

	// Set R0 pointer to end of string
	palindrome_loop_to_null:
		// Load string value into R2 and compare
		LDRB R2, [R0]
		CMP R2, #0x0
		ADD R0, #0x1
		BNE palindrome_loop_to_null

	// Set pointer to before string NULL terminator
	SUB R0, #0x2

	// Iterate pointers R1/R0 forward/backwards respectively until they pass
	palindrome_loop_until_tested:
		// Load and compare both characters
		LDRB R2, [R0]
		LDRB R3, [R1]
		CMP R2, R3
		BEQ continue_palindrome

		palindrome_check_capital:
			ADD R2, #32
			CMP R2, R3
			BEQ continue_palindrome

		palindrome_check_capital2:
			ADD R3, #32
			SUB R2, #32
			CMP R2, R3
			BNE palindrome_fail


		// Iterate pointers until they pass
		continue_palindrome:
			SUB R0, #0x1
			ADD R1, #0x1
			CMP R0, R1
			BGT palindrome_loop_until_tested

	// Set R0 to 1 if string is a palindrome, else 0
	palindrome_pass:
		B start_caesar_cipher

	palindrome_fail:
		LDR R0, =#0x0
		BX LR


