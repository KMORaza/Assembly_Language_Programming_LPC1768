;; 52 Cards Game
;; Created: November 2021
;;;;;;;;;;;;;;;;;;;;;;;;;

; Directives
          	PRESERVE8
          	THUMB      
; Vector Table Mapped to Address 0 at Reset
; Linker requires __Vectors to be exported
          	AREA    RESET, DATA, READONLY
          	EXPORT  __Vectors
__Vectors
     	    DCD  0x20001000     ; stack pointer value when stack is empty
          	DCD  Reset_Handler  ; reset vector
          	ALIGN
; Linker requires Reset_Handler
SRAM_BASE EQU 0x04000000
          	AREA    MYCODE, CODE, READONLY
          	ENTRY
        	EXPORT Reset_Handler
Reset_Handler
			LDR R0, =0x4000C000  ; UART0 base address
			LDR R1, =0x0000000C  ; Enable FIFO, 8-bit data, 1 stop bit, no parity
			STR R1, [R0, #0x0C]  ; UART0 LCR register
			; Seed random number generator
			BL SeedRandom
			; Shuffle the deck of cards
			BL ShuffleDeck
GameLoop
			; Draw a card
			BL DrawCard
			; Display the card on LCD
			BL DisplayCardOnLCD
			; Wait for user input or implement game logic
			B GameLoop
; Function to seed the random number generator
SeedRandom
			LDR R0, =RandomSeed
			LDR R1, =12345
			STR R1, [R0]
			BX LR
; Function to generate a random number (0 to max-1)
Random
			LDR R0, =RandomSeed
			LDR R1, [R0]
			MOV R2, #1103515245
			MUL R1, R1, R2
			ADD R1, R1, #12345
			STR R1, [R0]
			MOV R0, R1
			BX LR
; Function to shuffle the deck of cards
ShuffleDeck
			LDR R0, =Deck
			MOV R1, #51
			ShuffleLoop
			BL Random
			MOV R2, R0, LSL #2
			LDR R3, [R2]
			LDR R4, [R0, R1, LSL #2]
			STR R3, [R0, R1, LSL #2]
			STR R4, [R2]
			SUB R1, R1, #1
			CMP R1, #0
			BGT ShuffleLoop
			BX LR
; Function to draw a card from the deck
DrawCard
			LDR R0, =Deck
			LDR R1, [R0]
			ADD R0, R0, #4
			BX LR
; Function to display the card on LCD
DisplayCardOnLCD
			; Replace this section with your actual LCD display code
			LDR R0, =0x4000C000  ; UART0 base address
			LDR R1, [R0]          ; Load the drawn card index
			BL DisplayNumberOnUART
			BX LR
; Function to display a number on UART
DisplayNumberOnUART
			; Replace this section with your actual UART display code
			LDR R2, =0x4000C000  ; UART0 base address
			LDR R3, [R2, #0x18]  ; UART0 FR register
			TST R3, #0x20        ; Check if the UART transmitter is empty
			BEQ .                ; Wait until the transmitter is empty
			STR R1, [R2]          ; Send the number to UART
			BX LR
; Deck of cards (52 cards represented as their indices)
Deck
			DCD 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51
; Random seed for the random number generator
RandomSeed
			DCD 0
