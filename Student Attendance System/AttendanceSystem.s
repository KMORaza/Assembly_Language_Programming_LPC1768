;; Student Attendance System
;; Created: November 2021
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
            PRESERVE8
            THUMB
            AREA    RESET, DATA, READONLY
            EXPORT  __Vectors
__Vectors
            DCD  0x20001000     ; stack pointer value when stack is empty
            DCD  Reset_Handler  ; reset vector
            ALIGN
SRAM_BASE EQU 0x04000000
            AREA    MYCODE, CODE, READWRITE
            ENTRY
			EXPORT Reset_Handler
Reset_Handler
; Constants
MAX_STUDENTS EQU 10
; Data Section
SECTION DATA: DATA
studentsPresent DCB MAX_STUDENTS
attendanceStatus DCB MAX_STUDENTS
currentStudent DCD 0
; Code Section
SECTION CODE: CODE
ENTRY
; Main function
main
			BL displayWelcome
			BL takeAttendance
			BL displayAttendance
			; Exit the program
			BX LR
; Helper functions
displayWelcome
			; Display welcome message
			; Replace with actual display code
			MOV R0, #welcomeMessage
			BL displayString
			BX LR
takeAttendance
			LDR R1, =studentsPresent
			LDR R2, =attendanceStatus
			; Iterate through students
			MOV R3, #0
			attendanceLoop
					LDR R4, [R1, R3, LSL #2] ; Load student ID
					CMP R4, #0 ; Check if student ID is 0 (end of list)
					BEQ attendanceDone
			; Display student ID and prompt for attendance status
			MOV R0, R4
			BL displayStudentID
			BL readAttendanceStatus
			; Store attendance status
			STRB R5, [R2, R3]
			ADD R3, R3, #1 ; Move to the next student
			B attendanceLoop
			attendanceDone
			BX LR
displayAttendance
			LDR R1, =studentsPresent
			LDR R2, =attendanceStatus
			; Iterate through students
			MOV R3, #0
			attendanceDisplayLoop
					LDR R4, [R1, R3, LSL #2] ; Load student ID
					CMP R4, #0 ; Check if student ID is 0 (end of list)
					BEQ displayAttendanceDone
			; Display student ID and attendance status
			MOV R0, R4
			BL displayStudentID
			LDRB R5, [R2, R3]
			BL displayAttendanceStatus
			ADD R3, R3, #1 ; Move to the next student
			B attendanceDisplayLoop
			displayAttendanceDone
			BX LR
displayString
			; Replace with actual display code
			MOV R2, #0
			MOV R3, #1
			MOV R4, R0
			SWI 0
			BX LR
displayStudentID
			; Display student ID
			MOV R0, #studentIDMessage
			BL displayString
			BX LR
displayAttendanceStatus
			; Display attendance status
			CMP R5, #1
			BEQ displayAttendancePresent
			B displayAttendanceAbsent
displayAttendancePresent
			MOV R0, #attendancePresentMessage
			BL displayString
			BX LR
displayAttendanceAbsent
			MOV R0, #attendanceAbsentMessage
			BL displayString
			BX LR
readAttendanceStatus
			; Prompt user for attendance status (1 for present, 0 for absent)
			MOV R0, #attendancePromptMessage
			BL displayString
			MOV R0, #0
			MOV R2, #1
			SWI 1 ; Read integer input
			MOV R5, R0
			BX LR
; Strings
welcomeMessage: DCB "Welcome to the Attendance System", 10
                DCB "Enter attendance for each student:", 10
                DCB 0 ; Null terminator
studentIDMessage: DCB "Student ID: ", 0 ; Null terminator
attendancePresentMessage: DCB "Present", 10
					      DCB 0 ; Null terminator
attendanceAbsentMessage: DCB "Absent", 10
						 DCB 0 ; Null terminator
attendancePromptMessage: DCB "Enter attendance (1 for present, 0 for absent): ", 0 ; Null terminator
; End 
