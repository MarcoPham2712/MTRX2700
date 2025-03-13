.syntax unified
.thumb
.global main

.data
ascii_string:  .asciz "EntP\0"    @ string (null-terminated)
string_buffer: .space 10          @ string buffer for the converted string

.text
main:
    LDR   R0, =0                  @ 1 = convert to uppercase  0 = convert to lowercase
    LDR   R1, =ascii_string
    LDR   R2, =string_buffer
    MOV   R3, #0                  @ R3 is the index pointer starts at 0

loop:
    CMP   R0, #1                  @ Check the mode
    BEQ   Uppercase
    B     Lowercase

Uppercase:
    LDRB  R4, [R1, R3]            @ Load one character from the source into R4
    CMP   R4, #0                  @ Compare with null terminator '\0'
    BEQ   finish

    CMP   R4, #'a'                @ If character is less than 'a'
    BLT   store_ucha
    CMP   R4, #'z'                @ If character is greater than 'z'
    BGT   store_ucha
    SUB   R4, R4, #32             @ Otherwise, convert 'a'–'z' to uppercase by subtracting 32

store_ucha:
    STRB  R4, [R2, R3]            @ Store the (converted) character in the destination
    ADD   R3, #1                  @ Move the index to the next character
    B     loop

Lowercase:
    LDRB  R4, [R1, R3]            @ Load one character from the source into R4
    CMP   R4, #0                  @ Compare with null terminator '\0'
    BEQ   finish

    CMP   R4, #'A'                @ If character is less than 'A'
    BLT   store_lcha
    CMP   R4, #'Z'                @ If character is greater than 'Z'
    BGT   store_lcha
    ADD   R4, R4, #32             @ Otherwise, convert 'A'–'Z' to lowercase by adding 32

store_lcha:
    STRB  R4, [R2, R3]
    ADD   R3, #1                  @ Move the index to the next character
    B     loop

finish:
    MOV   R4, #0
    STRB  R4, [R2, R3]
    BKPT  #0
