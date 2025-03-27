# MTRX2700 2025 Assembly Lab
## Group: Give Us 0b1100100 Percent
**Members**
- Johnathan
- Shirui
- Ben
- Marco

Every exercise is separated into its own project. The various parts of these exercises (a, b, c, d) are completed by different members of the group and then put together in the exercise project. Each project has its own main.s file where test cases for each individual part are stored.
The integration exercise project copies all required parts from exercises 1 to 4 and runs in its own main file.
Function comments are presented to show inputs and outputs based on the register used.

## Exercise Responsibilities and Summaries
### Exercise 1 Memory and Pointers
```
Part A: Shirui
Part B: Johnathan, Ben
Part C: Shirui, Johnathan
```
In this project we define string functions to convert to lower/upper case, check if a string is a palindrome and perform Caesar ciphers on strings.

#### 1a.
Summary: 
Converts a given string to all uppercase or lowercase depending on a value given by the user. 
Usage:
Provide an .asciz string and load into R1 with a value of 0 or 1 in R0, 1 =  uppercase, 0 = lowercase.
Testing:
Provide various strings with varying R0 values and check memory to ensure strings were converted correctly.

#### 1b.
Summary: 
Checks if a given string is a palindrome.
Usage:
Provide the code with an .asciz string and load into R1.
Testing:
Provide multiple strings that are both palindromes and non-palindromes with randomly assorted uppercases (shows case-insensitive). Check memory for correct output.

#### 1c.
Summary: 
Caesar Ciphers a given string. 
Usage:
Provide the code with an .asciz string and load into R1.
Testing:
Provide multiple strings with randomly assorted uppercases (shows case-insensitive) and non-letter characters. Check memory for correct output.


### Exercise 2 Digital I/O
```
Part A: Marco, Ben, Johnathan
Part B: Marco, Ben, Johnathan
Part C: Marco, Ben, Johnathan
Part D: Ben
```
We begin by providing a function that can set the LEDs on the STM32F3 Discovery board using a bitmask, then apply it to a function that reads button input to modify that bitmask. We then combine this function with the previous string functions to visually show the number of vowel/consonants in a string.

#### 2a.
Summary: 
Loads a bit mask into R1.
Usage:
Define a bit mask and run.
Testing:
Provide the code with multiple different bit masks and visualise the change in LEDs.

#### 2b.
Summary: 
Reads button inputs from user and increments LED count accordingly.
Usage:
Press user button.
Testing:
Press the user button multiple times and visualise in the change in LEDs.

#### 2c.
Summary: 
Reads button inputs from the user and increments the LEDs until all are on, then each button push afterwards turns off an LED, this pattern is looped.
Usage:
Push the button to change the LEDs state
Testing:
Push the button multiple times until the LED circle is fully on then fully off, repeating the cycle until satisfied.

#### 2d.
Summary: 
Reads a given string and outputs the binary value of the number of vowels/consonants on the LEDs. The value shown is toggled with the button. 
Usage:
Provide the code with an .asciz string, then use the button to change the LED output to either vowel/consonant.
Testing:
Provide multiple strings with random uppercases (shows case-insensitive) and non-letter characters, then run the code and ensure the expected number of vowels/consonants are shown when the button is pushed.

### Exercise 3 Serial Communication
```
Part A: Marco, Shirui
Part B: Marco, Shirui, Johnathan
Part C: Marco，Shirui
Part D: Marco, Shirui
Part E: Marco, Shirui
```
We create functions to perform serial communication via UART. These include transmit, receive and echo functions which we use to create a communication interface between two boards.

#### 3a. 
Summary: In task 3a, we will try to transmit the given string provided to the interface, here we are using Putty for Windows. This string will only be transmitted through when the user pressed the button so we are implementing 2 sub-functions: checking if the button is pressed or not and transmitting the data from the given string to Putty. There is also a terminating character to determine whether the string is ended or not. We will call this function as “transmit function”

#### 3b
Summary: In this task we are requested to read the string given in the interface(Putty) and store it inside the STM32 using UART. This function is called the “receive function”. The process is the same as part a, with the exact requirement except the button. 

#### 3c
Summary: In this part, we will modify our code in part a to include the “change_clock_speed” function which is provided through the lecture. This function is made so that the frequency of the board is multiplied by 6 times. Therefore, the baud rate needed to be changed to the new value as well.

#### 3d
Summary: Here, we will integrate part a and b and make a function so that, whenever we type in something on the interface, it will receive and store in the board. Then it will be re-transmitted again to the interface. With the exact requirement provided in part a and b, we also include a function to tell “Successful” when the string is received - transmitted successfully. 

#### 3e
Summary: From part d, we will put everything together to communicate between 2 computers through 2 STM32 boards. It will use the program enhanced from pard d to receive and transmit string between computer - board. And we will use the pin - determined by the Hardware Document to transmit the data between 2 boards. The result is expected as whenever something is typed in Computer 1, it will transmit through the boards and show up in Computer 2, working as a text message. Moreover, the task also requires one of the ports to be USART for further using. 


### Exercise 4 Hardware Timers
```
Part A: Shirui
Part B: Shirui
Part C: Shirui
```
In this task, the Hardware Timers of the STM32 microcontroller must be used for the precise implementation of the delay and timing functions. The delay function is achieved by configuring the relevant register parameters of timer. These precise delays enable the control of hardware cycles, such as the lighting of LEDs, timed transmissions, etc.
#### 4a.
Summary: 
In task 4a, the program is required to initialise the TIM2 timer and GPIO clock, and to configure GPIOE to LED output mode. The prescaler of TIM2 should be set so that the counting frequency is 8MHz / (prescaler value + 1). Finally, the count value should be set according to this frequency in order to achieve one full count within one second. Finally, the LED blinks once per second through the delay cycle to achieve precise control of the timer.

#### 4b.
Summary: 
The program under discussion is based on the STM32 microcontroller, which has a system clock frequency of 8MHz. The actual counting frequency of the timer is reduced by configuring the prescaler of the timer. In order to achieve 10,000 counts in 1 second by counting every 0.1 milliseconds, the prescaler should be set to 799, which reduces the counting frequency to 10,000 Hz (i.e., one count every 0.1ms). The delay effect of one second is achieved by setting the comparison value of the timer and polling to check the status of the timer, thus finally determining whether 10,000 counts have been reached.


#### 4c.
Summary: 
In order to achieve a more accurate and fully hardware-controlled delay function, it is necessary to use the auto reload mechanism of the STM32 timer. Initially, the prescaler (TIM_PSC) and the auto-reload register (TIM_ARR) must be configured, and the auto-reload function (ARPE=1) must be enabled, thereby ensuring that the timer automatically resets to 0 once the count reaches the predetermined value. After starting the timer, the program simply detects the UIF bit in the status register (TIM_SR) to determine if an update event has occurred. Once UIF is set, it means that a timing cycle has been completed, and then you can execute the required delay action and clear UIF.



### Exercise 5 Integration
```
Board 1: Ben
Board 2: Johnathan
```
Combined the existing functions from the above exercises with minor additions such as using the stack, working around terminating characters and integrating delays. The code works in two parts where the first board receives a string from the PC and then deciphers if it is a palindrome or not. If the string is a palindrome it is then Caesar ciphered and then transmitted to the other board, if it is not a palindrome it is just transmitted. The second board then receives the string and deciphers it if it is a palindrome and then displays both the number of vowels and consonants in binary using a delay in the toggling of the LEDs. 


**Workspace Preparation:** Johnathan
*(copy files into 1 project, delete all main functions)*

