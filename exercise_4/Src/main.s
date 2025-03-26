.syntax unified
.thumb
.global main

#include "definitions.s"
#include "initialise.s"
#include "delay_4a.s"
#include "delay_period_demo_4b.s"
#include "hardware_delay_4c.s"

.text
main:
	// Test 4a
	B delay_4a

	// Test 4b
	//B delay_4b

	// Test 4c
	//B delay_4c
