.syntax unified
.thumb

#include "definitions.s"
#include "initialise.s"

.data
.align

hello_world_string: .asciz "Hello world!"

.text
port_forward:
	BL enable_power
	BL enable_peripheral_clocks
	BL enable_usart1_uart4_clocks
	BL use_uart4_pin_config
	BL configure_uart4
	BL finalise_uart4_config
