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
Part A: Marco
Part B: Marco, Shirui, Johnathan
Part C: Shirui
Part D: Marco, Shirui
Part E: Marco
```
We create functions to perform serial communication via UART. These include transmit, receive and echo functions which we use to create a communication interface between two boards.

### Exercise 4 Hardware Timers
```
Part A: Shirui
Part B: Shirui
Part C: Shirui
```

### Exercise 5 Integration
```
Board 1: Ben
Board 2: Johnathan
```
Combined the existing functions from the above exercises with minor additions such as using the stack, working around terminating characters and integrating delays to achieve the given task.
**Workspace Preparation:** Johnathan
*(copy files into 1 project, delete all main functions)*

