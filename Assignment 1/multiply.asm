; Author
; Name: Ö. Malik Kalembaþý
; Student ID: 150180112
; CRN: 11450

; Multiply 32-bit and one 16-bit number on the 8051 microcontroller
; The result is stored in registers r5, r4, r3, r2, r1, r0 from bank2, MSB to LSB.

org 0000h
ljmp main
org 010h

; You can use the example test case below.
; Select 1st number
; In this test case first number is selected as 00255605H.
;n1_d1 equ 00000000B 
;n1_d2 equ 00100101B 
;n1_d3 equ 01010110B
;n1_d4 equ 00000101B
; Select 2nd number
; In this test case second number is selected as 031CH.
;n2_d1 equ 00000011B
;n2_d2 equ 00011100B

; Note that, multiplication of 32-bit and 16-bit numbers can yield a result up to 48-bits.
; So, another test case that has 48-bit result is given to you as comments below.
; Select 1st number
; In this test case first number is selected as B7B4B605H.
n1_d1 equ 10110111B 
n1_d2 equ 10110100B 
n1_d3 equ 10110110B
n1_d4 equ 00000101B
; Select 2nd number
; In this test case second number is selected as 873CH.
n2_d1 equ 10000111B
n2_d2 equ 00111100B

main:
; Calculate and select which register bank that you should use 
; to store first number(32-bit) and second number(16-bit).

; Select register bank here, then store given numbers into that register. 

call BANK0	
;clears BANK0
mov r0, #00h	
mov r1, #00h
mov r2, #00h
mov r3, #00h
mov r4, #00h
mov r5, #00h
mov r6, #00h
mov r7, #00h

call BANK2	;store register bank
;clears BANK2
mov r0, #00h
mov r1, #00h
mov r2, #00h
mov r3, #00h
mov r4, #00h
mov r5, #00h
mov r6, #00h
mov r7, #00h

; Store 1st number
mov r0, #n1_d1  ; Store first digit of 1st number
mov r1, #n1_d2  ; Store second digit of 1st number
mov r2, #n1_d3  ; Store third digit of 1st number
mov r3, #n1_d4  ; Store fourth digit of 1st number
; Store 2nd number
mov r4, #n2_d1   ; Store first digit of 2nd number
mov r5, #n2_d2   ; Store second digit of 2nd number

; ----MULTIPLY/DIVIDE NUMBERS----

;r3*r5
mov a, r3
mov b, r5
call BANK0	;calculation and result bank
mul ab	
mov r0, a	;a keeps LSB of multiplication
mov r1, b	;b keeps MSB of multiplication
call CLEAR	;clears registers a and b

;r3*r4
call BANK2	;store register bank 
mov a, r3
mov b, r4
call BANK0	;calculation and result bank
mul ab
add a, r1	;adds LSB of multiplication to 16-9 bits of the result (with next line)
mov r1, a
mov a, b	;moves MSB of multiplication to register a for adding carry (only register a allows addc operation)
addc a, #00h	;adds carry (if any)
mov r2, a		;moves MSB of multiplication to 24-17 bits of the result
mov a, #00h		;clears a
addc a, #00h	;adds carry (if any)
mov r3, a		;moves carry to 32-25 bits of the result
call CLEAR		;clears a and b

;the next implementations are repeating the previous section

;r2*r5
call BANK2	;store register bank 
mov a, r2
mov b, r5
call BANK0	;calculation and result bank
mul ab
add a, r1
mov r1, a
mov a, b
addc a, r2
mov r2, a
mov a, #00h
addc a, #00h
mov r3, a
call CLEAR

;r2*r4
call BANK2	;store register bank 
mov a, r2
mov b, r4
call BANK0	;calculation and result bank
mul ab
add a, r2
mov r2, a
mov a, b
addc a, r3
mov r3, a
mov a, #00h
addc a, #00h
mov r4, a
call CLEAR

;r1*r5
call BANK2	;store register bank 
mov a, r1
mov b, r5
call BANK0	;calculation and result bank
mul ab
add a, r2
mov r2, a
mov a, b
addc a, r3
mov r3, a
mov a, #00h
addc a, #00h
mov r4, a
call CLEAR

;r1*r4
call BANK2	;store register bank 
mov a, r1
mov b, r4
call BANK0	;calculation and result bank
mul ab
add a, r3
mov r3, a
mov a, b
addc a, r4
mov r4, a
mov a, #00h
addc a, #00h
mov r5, a
call CLEAR

;r0*r5
call BANK2	;store register bank 
mov a, r0
mov b, r5
call BANK0	;calculation and result bank
mul ab
add a, r3
mov r3, a
mov a, b
addc a, r4
mov r4, a
mov a, #00h
addc a, #00h
mov r5, a
call CLEAR

;r0*r4
call BANK2	;store register bank 
mov a, r0
mov b, r4
call BANK0	;calculation and result bank
mul ab
add a, r4
mov r4, a
mov a, b
addc a, r5
mov r5, a
mov a, #00h
addc a, #00h
mov r6, a
call CLEAR

;move results to BANK2 (requiered according to mod(4))
mov a, r0
mov b, r1
call BANK2
mov r0, a
mov r1, b
call BANK0
mov a, r2
mov b, r3
call BANK2
mov r2, a
mov r3, b
call BANK0
mov a, r4
mov b, r5
call BANK2
mov r4, a
mov r5, b

HALT:	;terminates the program
jmp HALT

BANK0:	;switches to bank0 (store bank)
mov psw, #00h
ret

BANK2:	;switches to bank2 (result bank)
mov psw, #10h
ret

CLEAR:	;clears a and b
mov a, #00h
mov b, #00h
ret


; You should explain where you stored your result.
; The result is stored in registers r5, r4, r3, r2, r1, r0 from bank2, MSB to LSB.
end
