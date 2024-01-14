;;; Text Editor
;;; Created: Novermber 2021
;;;;;;;;;;;;;;;;;;;;;;;;;;;
            PRESERVE8
            THUMB
            AREA    RESET, DATA, READONLY
            EXPORT  __Vectors
__Vectors
            DCD  0x20001000     ; stack pointer value when stack is empty
            DCD  Reset_Handler  ; reset vector
            ALIGN
SRAM_BASE 	EQU 0x04000000
            AREA    MYCODE, CODE, READWRITE
            ENTRY
            EXPORT Reset_Handler
Reset_Handler
			; Constants
			BUFFER_SIZE EQU 256
			; Data Section
			SECTION DATA: DATA
			buffer: SPACE BUFFER_SIZE ; Buffer to store text
			cursor: DCD 0             ; Cursor position
; Code Section
SECTION 	CODE: CODE
ENTRY

; Main function
main
			BL clearScreen
            BL printMenu
            ; Wait for user input
			MOV R0, #buffer
			BL readString
			; Process user input
			LDR R1, =buffer
			LDR R2, [R1]
			CMP R2, #0
			BEQ main ; If input is empty, show menu again
			LDR R3, [R2]
			CMP R3, #0
			; Check the first character of the input
			LDRB R4, [R2, #1]
			CMP R4, #10 ; Newline character
			BEQ processMenu
			; If the first character is not a newline, it's an invalid command
			BL clearScreen
			BL printInvalidCommand
			B main
processMenu
			LDRB R5, [R2, #1]
			CMP R5, #69 ; 'E' for Edit
			BEQ edit
			CMP R5, #86 ; 'V' for View
			BEQ view
			CMP R5, #68 ; 'D' for Delete
			BEQ delete
			CMP R5, #83 ; 'S' for Save
			BEQ save
			CMP R5, #81 ; 'Q' for Quit
			BEQ exit
			; Invalid command
			BL clearScreen
			BL printInvalidCommand
			B main
edit
			BL clearScreen
			BL printEditHeader
			MOV R0, #buffer
			BL readString
			B main
view
			BL clearScreen
			BL printViewHeader
			LDR R0, =buffer
			BL printString
			B main
delete
			BL clearScreen
			BL printDeleteHeader
			MOV R0, #buffer
			BL clearString
			B main
save
			BL clearScreen
			BL printSaveHeader
			MOV R0, #buffer
			BL saveToFile
			B main
exit
			; Exit the program
			BX LR

; Helper functions
clearScreen
			; Clear the screen
			MOV R0, #0
			MOV R1, #0
			MOV R2, #0
			MOV R3, #80
			MOV R4, #25
			MOV R5, #7
			MOV R6, #0
			SWI 0
			; Return
			BX LR
printMenu
			; Print the menu
			LDR R0, =menuText
			BL printString
			BX LR
printInvalidCommand
			; Print invalid command message
			LDR R0, =invalidCommandText
			BL printString
			BX LR
printEditHeader
			; Print edit header
			LDR R0, =editHeaderText
			BL printString
			BX LR
printViewHeader
			; Print view header
			LDR R0, =viewHeaderText
			BL printString
			BX LR
printDeleteHeader
			; Print delete header
			LDR R0, =deleteHeaderText
			BL printString
			BX LR
printSaveHeader
			; Print save header
			LDR R0, =saveHeaderText
			BL printString
			BX LR
printString
			; Print a null-terminated string
			LDR R1, [R0]
printStringLoop
			LDRB R2, [R1], #1
			CMP R2, #0
			BEQ printStringDone
			MOV R0, #1
			MOV R3, #1
			MOV R4, R2
			SWI 0
			B printStringLoop
printStringDone
			BX LR
readString
			; Read a string from the console
			MOV R0, #0
			MOV R1, #buffer
			MOV R2, #BUFFER_SIZE
			MOV R3, #0
			SWI 1
			BX LR
clearString
			; Clear the buffer
			MOV R0, #buffer
			MOV R1, #BUFFER_SIZE
			MOV R2, #0
			BL clearMemory
			BX LR
clearMemory
			; Clear memory
			STRB R2, [R0], #1
			SUBS R1, R1, #1
			BNE clearMemory
			BX LR
saveToFile
			; Save the contents to a file
			BX LR
; Strings
			menuText:       	DCB "Menu:", 10
								DCB "E: Edit", 10
								DCB "V: View", 10
								DCB "D: Delete", 10
								DCB "S: Save", 10
								DCB "Q: Quit", 10
								DCB 0 ; Null terminator
			invalidCommandText: DCB "Invalid command. Please try again.", 10
								DCB 0 ; Null terminator
			editHeaderText: 	DCB "Editing...", 10
								DCB 0 ; Null terminator
			viewHeaderText: 	DCB "Viewing...", 10
								DCB 0 ; Null terminator
			deleteHeaderText: 	DCB "Deleting...", 10
								DCB 0 ; Null terminator
			saveHeaderText: 	DCB "Saving...", 10
								DCB 0 ; Null terminator

; END
