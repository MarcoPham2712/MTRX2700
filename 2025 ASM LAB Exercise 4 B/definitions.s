.syntax unified
.thumb
@ Clock setting register (base address and offsets)
.equ RCC, 0x40021000	     @ Base register for resetting and clock settings
@ Registers for enabling clocks
.equ AHBENR, 0x14            @ Enable peripherals
.equ APB1ENR, 0x1C           @ Enable peripherals on bus 1
.equ APB2ENR, 0x18           @ Enable peripherals on bus 2
@ Bit positions for enabling GPIO in AHBENR
.equ GPIOA_ENABLE, 17
.equ GPIOC_ENABLE, 19
.equ GPIOE_ENABLE, 21
@ Enable the clocks for timer 2
.equ RCC, 0x40021000
.equ APB1ENR, 0x1C
.equ TIM2EN, 0
.equ GPIOA, 0x48000000	     @ Base register for GPIOA (pa0 is the button)
.equ GPIOC, 0x48000800	     @ Base register for GPIOA (pa0 is the button)
.equ GPIOE, 0x48001000	     @ Base register for GPIOE (pe8-15 are the LEDs)
@ GPIO register offsets
.equ MODER, 0x00	         @ Begister for setting the port mode (in/out/etc)
.equ ODR, 0x14	             @ GPIO output register
.equ GPIOx_AFRH, 0x24        @ Bffset for setting the alternate pin function
@ Timer defined values
.equ TIM2, 0x40000000	     @ Base address for the general purpose timer 2 (TIM2)
.equ TIM_CR1, 0x00	         @ Bontrol registers
.equ TIM_CCMR1, 0x18         @ Bompare capture settings register
.equ TIM_CNT, 0x24           @ The actual counter location
.equ TIM_ARR, 0x2C           @ The register for the auto-reload
.equ TIM_PSC, 0x28           @ Prescaler
.equ TIM_CCER, 0x20          @ Control register for output/capture
.equ TIM_CCR1, 0x34          @ Capture/compare register for channel 1
.equ TIM_SR, 0x10            @ Status of the timer
.equ TIM_DIER, 0x0C          @ Enable interrupts
