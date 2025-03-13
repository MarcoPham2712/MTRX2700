.syntax unified
.thumb

.data
asciii_string: .asciz "ABcd\0"
string_bufferr: .space 10          @ Destination buffer (10 bytes)

.text
start_caesar_cipher:
    LDR R0,=3            	@ Caesar cipher shift (could be 3 or -3)
    LDR R1,=asciii_string
    LDR R2,=string_bufferr
    LDR R3,=0x00         	@ R3 is the index (starting at 0)

caesar_cipher:
    LDRB R4,[R1,R3]     	@ Read one character from the string
    CMP R4,#0            	@ Check if it is '\0'
    BEQ finished_string

    CMP R4,#'A'
    BLT store_character

    CMP R4,#'Z'
    BGT check_lowercase

    B uppercase

check_lowercase:
    CMP R4,#'a'
    BLT store_character

    CMP R4,#'z'
    BGT store_character

    B lowercase

uppercase:
    MOV R5,#0           	 @ Clear R5
    SUB R5,R4,#'A'      	@ Find position in the alphabet (0–25)
    ADD R5,R5,R0        	@ Add the shift (R0)

    CMP R5,#0            	@ Check if below 0
    BGE check_upper_26
    ADD R5,R5,#26       	@ If below 0, wrap around (add 26)

check_upper_26:
    CMP R5,#26           	@ If 26 or more, we need to wrap
    BLT normal_case_upper
    SUB R5,#26           	@ Subtract 26 to wrap within 0–25

    ADD R4,R5,#'A'      	@ Convert back to ASCII
    B store_character

normal_case_upper:
    ADD R4,R5,#'A'      	@ Convert the shifted value back to uppercase
    B store_character

lowercase:
    MOV R5,#0            	@ Clear R5
    SUB R5,R4,#'a'      	@ Find position in the alphabet (0–25)
    ADD R5,R5,R0        	@ Add the shift (R0)

    CMP R5,#0            	@ Check if below 0
    BGE check_lower_26
    ADD R5,R5,#26       	@ If below 0, wrap around

check_lower_26:
    CMP R5,#26
    BLT normal_case_lower
    SUB R5,#26          	 @ Wrap if >= 26
    ADD R4,R5,#'a'      	@ Convert back to ASCII
    B store_character

normal_case_lower:
    ADD R4,R5,#'a'      	@ Convert the shifted value back to lowercase
    B store_character

store_character:
    STRB R4,[R2, R3]     	@ Store the processed character in the destination
    ADD R3,R3,#1        	@ Move to the next character
    B caesar_cipher       	@ Repeat for the next source character

finished_string:
    MOV R4,#0            	@ Load 0 into R4
    STRB R4,[R2, R3]
    BKPT #0







