.syntax unified
.thumb

.text

// Registers used: R0, R1, R2, R3, R4
// Cipher key and string address should be pushed onto stack before calling
// Result is stored at the given string address (2nd argument)
// R0: Cipher key
// R1: String address
// R2: Character being ciphered
// R3: 'A' or 'a' to indicate if cipher is upper/lower
// R4: Result of division required for modulo operator
// R5: Modulo divisor
caesar_cipher:
	// Register setup
	POP {R0, R1} // Pop the cipher key and string from the stack
	SUB R1, #1   // Start before the string (because pre-increment loop)
	MOV R5, #26

	// Convert cipher key to positive value in range [0, 25]
	SDIV R4, R0, R5
	MUL R4, R5
	SUB R0, R4
	CMP R0, #0 // Add 26 to negative values
	BGE cipher_next
	ADD R0, R5

	cipher_next:
		// Iterate string until terminating NULLL
		LDRB R2, [R1, #1]!
		CMP R2, #0
		BEQ cipher_finish

		// Ignore values before and after the alphabet
		CMP R2, #'A'
		BLT cipher_next
		CMP R2, #'z'
		BGT cipher_next

		// Check if uppercase or lower case
		CMP R2, #'Z'
		MOV R3, #'A'
		BLE perform_cipher

		CMP R2, #'a'
		MOV R3, #'a'
		BGE perform_cipher

	perform_cipher:
		// Convert letter to a number [0, 25] and perform cipher
		SUB R2, R3
		ADD R2, R0

		// Modulo operation (subtract highest multiple of 26)
		UDIV R4, R2, R5
		MUL R4, R5
		SUB R2, R4

		// Convert number back to letter of given case, store in R1
		ADD R2, R3
		STRB R2, [R1]
		B cipher_next

	cipher_finish:
		BX LR

