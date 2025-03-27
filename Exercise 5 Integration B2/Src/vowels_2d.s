.syntax unified
.thumb

.text
Vowels:
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
    	LDR R0, =test_string // Reload the string from the start
    count_vowels:
    	LDRB R2, [R0], #1	// After loading byte pointer is incremented by 1
    	//Check if the loaded byte is equal to a vowel, if so add 1 to R3 (vowel counter)
    	//Loop until end of the string (null terminator)
    	CMP R2, #0
    	BEQ end
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
    	CMP R2, 'E'
    	BEQ add_vowel
    	CMP R2, 'I'
    	BEQ add_vowel
    	CMP R2, 'O'
    	BEQ add_vowel
    	CMP R2, 'U'
    	BEQ add_vowel
    	CMP R2, 'A'
    	BEQ add_vowel
    	B count_vowels

    add_vowel:
    	ADD R3, #0b1
    	B count_vowels
    end:
    	//Subtract vowles from letters to get consonants count
    	SUB R1, R3
    	BX LR

