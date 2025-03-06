
/*
 * Checks if the string in register R1 is a palindrome
 * (same backwards and forwards)
 * R0 is used as a backwards iterating pointer
 * Result is stored in R0 (1 is palindrome, 0 is not)
 */
palindrome:
	// Load the address of the string into R0
	LDR R0, R1

	// Set R0 pointer to end of string
	palindrome_loop_to_null:
		CMP R0, #0x0
		ADD R0, #0x1
		BNE palindrome_loop_to_null

	// Set pointer to before string NULL terminator
	SUB R0, #0x2

	// Iterate pointers R1/R0 forward/backwards respectively until they pass
	palindrome_loop_until_tested:
		// Load and compare both characters
		LDRB R2, R0
		LDRB R3, R1
		CMP R2, R3
		BNE palindrome_fail

		// Iterate pointers until they pass
		SUB R0, #0x1
		ADD R1, #0x1
		CMP R0, R1
		BGT palindrome_loop_until_tested

	// Set R0 to 1 if string is a palindrome, else 0
	palindrome_pass:
		LDR R0, #0x1
		BX LR

	palindrome_fail:
		LDR R0, #0x0
		BX LR



