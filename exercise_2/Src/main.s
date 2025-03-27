.syntax unified
.thumb
.global main

#include "definitions.s"
#include "initialise.s"
#include "set_led_state_2a.s"
#include "light_up_leds_2b.s"
#include "light_down_leds_2c.s"
#include "vowels_2d.s"

.data
test_string: .asciz "abcde.fghi44jkl,mnopq1"
//4 vowels 13 consonants
//test_string: .asciz "abbba"


.text
main:
    // Initialise GPIO registers
	BL enable_peripheral_clocks // Branch with link to set the clocks for the I/O and UART
	BL Set_LED_to_output        // Once the clocks are started, need to initialise the discovery board I/O

    // Test 2a
	BL Set_LED_state

    // Test 2b (infinite loop)
    //B entry_2b

    // Test 2c (infinite loop)
    //B start_user_led_ripple

    // Test 2d (infinite loop)
    LDR R0, =test_string
    B Vowels
