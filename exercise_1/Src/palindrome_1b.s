.syntax unified
.thumb

.text
// Checks if the string in register R1 is a palindrome
// (same backwards and forwards)
// R0 is used as a backwards iterating pointer and then to return the result
// R2 is used to test the character in R0
// R3 is used to test the character in R1
// Result is stored in R0 (1 is palindrome, 0 is not)
palindrome:
	MOV R0, R1 // Load string from R1 into R0

	// Set R0 pointer to end of string
	palindrome_loop_to_null:
		// Load string value into R2 and compare
		LDRB R2, [R0]
		CMP R2, #0
		ADD R0, #1
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

	// Return 1 if string is a palindrome, else 0
	palindrome_pass:
		MOV R0, #1
		BX LR

	palindrome_fail:
		MOV R0, #0
		BX LR


