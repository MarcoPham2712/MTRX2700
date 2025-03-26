.syntax unified
.thumb

#include "definitions.s"

.data // Variables
initial_led_state: .byte 0b00000000

.text
// Sets the LEDs from the bitmask stored in R3
// Bitmask is anticlockwise from West LED
set_led_state:
	// Replace GPIOE ODR with R3 bitmask
	LDR R1, =GPIOE
	STRB R3, [R1, #ODR + 1]

	BX LR

start_user_led_ripple:
	LDR R3, =initial_led_state
	LDR R4, =0x1

// LEDs count up on button presses until they all light up
// They then count down until they are all off
user_led_ripple:
	// Await button press
	LDR R0, =GPIOA
	LDR R1, [R0, #IDR]
	TST R1, #0x1
	BEQ user_led_ripple

	// Await button release
	wait_for_button_release:
	LDR R1, [R0, #IDR]
	TST R1, #0x1
	BNE wait_for_button_release

	// Shift LED bitmask and perform an OR with current state
	LSL R3, R3, #0x1
	ORR R3, R3, R4

	// If all LEDs are on/off change state
	check_state:
	AND R3, R3, #0b11111111   // Clear bits left-shifted past bit 8
	CMP R3, #0b00000000
	BEQ state_switch_increasing
	CMP R3, #0b11111111
	BEQ state_switch_depleting
	B state_endif

	state_switch_increasing:  // Increasing state
	MOV R4, #0x1
	B state_endif

	state_switch_depleting:   // Depleting state
	MOV R4, #0x0
	B state_endif

	state_endif:

	// Set LEDs and loop
	BL set_led_state
	B user_led_ripple
