;;; SIMPLE CALCULATOR
;;; Created: November 2021
;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Directives
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
; Function to parse and calculate the input expression
ParseAndCalculate
			; Inputs: R0 - pointer to the input buffer
			; Outputs: R0 - result of the calculation
		    MOV R1, R0  ; Copy the pointer to R1 for parsing
			; Initialize variables
			MOV R0, #0    ; Accumulator for the result
			MOV R2, #0    ; Temporary storage for operands
			MOV R3, #0    ; Operator flag (0: no operator, 1: +, 2: -, 3: *, 4: /)
			MOV R4, #0    ; Error flag (0: no error, 1: error)
ParseLoop
			; Read the next character from the input buffer
			LDRB R5, [R1], #1
			; Check for the end of the string
			CMP R5, #0
			BEQ ParseDone
			; Check if the character is a digit
			CMP R5, #'0'
			BLT CheckOperator
			CMP R5, #'9'
			BGT CheckOperator
			; Convert the ASCII digit to an integer
			SUB R5, R5, #'0'
			; Update the operand
			MOV R2, R2, LSL #3  ; Multiply the current operand by 10
			ADD R2, R2, R5      ; Add the new digit to the operand
			B ParseLoop
CheckOperator
			; Check if the character is an operator
			CMP R5, #'+'
			BEQ SetAddOperator
			CMP R5, #'-'
			BEQ SetSubOperator
			CMP R5, #'*'
			BEQ SetMulOperator
			CMP R5, #'/'
			BEQ SetDivOperator
			; Invalid character, set error flag
			MOV R4, #1
			B ParseDone
SetAddOperator
			MOV R3, #1
			B ParseLoop
SetSubOperator
			MOV R3, #2
			B ParseLoop
SetMulOperator
			MOV R3, #3
			B ParseLoop
SetDivOperator
			MOV R3, #4
			B ParseLoop
ParseDone
			; Perform the final calculation
			CMP R3, #0
			BEQ ParseError
			; Check for division by zero
			CMP R3, #4
			BEQ CheckDivByZero
			; Perform the calculation based on the operator
			CMP R3, #1
			BEQ PerformAddition
			CMP R3, #2
			BEQ PerformSubtraction
			CMP R3, #3
			BEQ PerformMultiplication
			CMP R3, #4
			BEQ PerformDivision
PerformAddition
			ADD R0, R0, R2
			B CalculationDone
PerformSubtraction
			SUB R0, R0, R2
			B CalculationDone
PerformMultiplication
			MUL R0, R0, R2
			B CalculationDone
PerformDivision
			SDIV R0, R0, R2
CalculationDone
			; Check for any errors during calculation
			CMP R4, #1
			BEQ ParseError
			BX LR
CheckDivByZero
			; Check for division by zero
			CMP R2, #0
			BEQ ParseError
			; Division by zero error
			MOV R4, #1
			B ParseDone
ParseError
			; Handle parsing errors (e.g., invalid input, division by zero)
			MOV R0, #0xFFFFFFFF  ; Set result to a special value indicating an error
			BX LR
