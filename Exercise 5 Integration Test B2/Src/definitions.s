// Reset and Clock Control Base Address
.equ RCC, 0x40021000


@ base register for resetting and clock settings
.equ RCC, 0x40021000
.equ AHBENR, 0x14	@ register for enabling clocks
.equ APB1ENR, 0x1C
.equ APB2ENR, 0x18
.equ AFRH, 0x24
.equ AFRL, 0x20
.equ RCC_CR, 0x00 @ control clock register
.equ RCC_CFGR, 0x04 @ configure clock register



// RCC Register Offsets
.equ RCC_CR,      0x00  // Clock Control Register
.equ RCC_CFGR,    0x04  // Clock Configuration Register
.equ RCC_AHBENR,  0x14  // Advanced High-performance Bus Clock Enable Register
.equ RCC_APB2ENR, 0x18  // Advanced Peripheral Bus 2 Clock Enable Register
.equ RCC_APB1ENR, 0x1C  // Advanced Peripheral Bus 1 Clock Enable Register

// GPIO Base Addresses
.equ GPIOA, 0x48000000
.equ GPIOB, 0x48000400
.equ GPIOC, 0x48000800
.equ GPIOD, 0x48000C00
.equ GPIOE, 0x48001000

// GPIO Register Offsets
.equ GPIO_MODER,   0x00 // Mode Register
.equ GPIO_OTYPER,  0x04 // Output Type Register
.equ GPIO_OSPEEDR, 0x08 // Output Speed Register
.equ GPIO_PUPDR,   0x0C // Pull-Up/Pull-Down Register
.equ GPIO_IDR,     0x10 // Input Data Register
.equ GPIO_ODR,     0x14 // Output Data Register
.equ GPIO_AFRL,    0x20  // Alternate Function Register (Low)
.equ GPIO_AFRH,    0x24  // Alternate Function Register (High)

// AHB Peripheral Clock Enable Register Bits
.equ AHBENR_IOPAEN_BIT, 17
.equ AHBENR_IOPBEN_BIT, 18
.equ AHBENR_IOPCEN_BIT, 19
.equ AHBENR_IOPDEN_BIT, 20
.equ AHBENR_IOPEEN_BIT, 21

// Universal Synchronous/Asynchronous Receiver Transmitter (USART)
.equ USART1, 0x40013800 // APB2
.equ USART1_EN_BIT, 14  // RCC_APB2ENR

// Universal Asynchronous Receiver Transmitter (UART)
.equ UART4, 0x40004C00 // APB1
.equ UART4_EN_BIT, 19  // RCC_APB1ENR

// USART Register Offsets
.equ USART_CR1, 0x00 // Control Register 1
.equ USART_BRR, 0x0C // Baud Rate Register
.equ USART_RQR, 0x18 // Request Register
.equ USART_ISR, 0x1C // Interrupt and Status Register
.equ USART_ICR, 0x20 // Interrupt Flag Clear Register
.equ USART_RDR, 0x24 // Receive Data Register
.equ USART_TDR, 0x28 // Transmit Data Register

// USART Control Register 1 Bits
.equ USART_CR1_UE_BIT, 0 // USART Enable
.equ USART_CR1_RE_BIT, 2 // Receiver Enable
.equ USART_CR1_TE_BIT, 3 // Transmitter Enable

// USART Request Register Bits
.equ USART_RQR_RXFRQ_BIT, 3 // Receive Data Flush Request

// USART Interrupt and Status Register Bits
.equ USART_ISR_FE_BIT,   1 // Frame Error
.equ USART_ISR_ORE_BIT,  3 // Overrun Error
.equ USART_ISR_RXNE_BIT, 5 // Read Data Register Not Empty
.equ USART_ISR_TXE_BIT,  7 // Transmit Data Register Empty

// USART Interrupt Flag Clear Register Bits
.equ USART_ICR_ORECF_BIT, 3 // Overrun Error Clear Flag
.equ USART_ICR_FECF_BIT,  1 // Frame Error Clear Flag



.equ GPIOA_ENABLE, 17	@ enable bit for GPIOA
.equ GPIOB_ENABLE, 18	@ enable bit for GPIOB
.equ GPIOC_ENABLE, 19	@ enable bit for GPIOC
.equ GPIOD_ENABLE, 20	@ enable bit for GPIOD
.equ GPIOE_ENABLE, 21	@ enable bit for GPIOE


@ setting the clock speed higher using the PLL clock option
.equ HSEBYP, 18	@ bypass the external clock
.equ HSEON, 16 @ set to use the external clock
.equ HSERDY, 17 @ wait for this to indicate HSE is ready
.equ PLLON, 24 @ set the PLL clock source
.equ PLLRDY, 25 @ wait for this to indicate PLL is ready
.equ PLLEN, 16 @ enable the PLL clock
.equ PLLSRC, 16
.equ USBPRE, 22 @ with PLL active, this must be set for the USB

.equ PWREN, 28
.equ SYSCFGEN, 0
