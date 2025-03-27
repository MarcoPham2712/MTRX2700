.syntax unified
.thumb

.global main

#include "port_forward_3e_b2.s"

.data

.text
main:
	B port_forward_b2
