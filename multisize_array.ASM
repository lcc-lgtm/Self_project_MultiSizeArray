.MODEL SMALL
.STACK 100
.DATA
	greet	db	0ah,0dh,"Welcome to CURSOR.ASM testing...",0ah,0dh,0ah,0dh
			db	"	1	-	 1-byte array",0ah,0dh
			db	"	2	-	 2-byte array",10,13
			db	"	3	-	 4-byte array",0ah,0dh
			db	"	4	-	 8-byte array",10,13
			db	"	5	-	10-byte array",0ah,0dh
			db	0ah,0dh,"	0	-	exit program",0ah,0dh,"$"
		
	_return_str	 db	" << Press 'ENTER' key to return >> $"
	_exit_str	 db	"   << Press 'ESC' key to exit >> $"
	_enter		 db	"ENTER : $"
	_enter_msg	 db " << Press ENTER to continue >> $"
	buffer 		 db 	?
	printer_msg	 db 0ah,0dh," << Printed information >> $"
	system_start db	0ah,0dh," << Start your demo >> $"

	INVALID_MSG	 db	" Invalid input ! $"
	NL 			 db  0ah,0dh,"$"
	
	; 1-byte array
	one_byte_array		db	?,?,?,?
	one_byte_array_len	EQU	4
	
	; 2-byte array
	two_byte_array		dw	?,?,?,?
	two_byte_array_len	EQU	4
	; 2-byte array input string
	two_byte_array_buffer 				LABEL BYTE
	two_byte_array_buffer_maximum_len	db	03h		; 2 ch + 0Dh
	two_byte_array_buffer_actual_len	db	?
	two_byte_array_outputstring			db	03h dup('$')
	
	; 4-byte array
	four_byte_array		dd	?,?,?,?
	four_byte_array_len	EQU	4
	; 4-byte array input string
	four_byte_array_buffer 				LABEL BYTE
	four_byte_array_buffer_maximum_len	db	05h
	four_byte_array_buffer_actual_len	db	?
	four_byte_array_outputstring		db	05h dup('$')
	
	; 8-byte array
	eight_byte_array	 dq	 ?,?,?,?
	eight_byte_array_len EQU 4
	; 8-byte array input string
	eight_byte_array_buffer 			LABEL BYTE
	eight_byte_array_buffer_maximum_len	db	09h
	eight_byte_array_buffer_actual_len	db	?
	eight_byte_array_outputstring		db	09h dup('$')
	
	; 10-byte array
	ten_byte_array		dt	?,?,?,?
	ten_byte_array_len	EQU	4
	; 10-byte array input string
	ten_byte_array_buffer 				LABEL BYTE
	ten_byte_array_buffer_maximum_len	db	0Bh
	ten_byte_array_buffer_actual_len	db	?
	ten_byte_array_outputstring			db	0Bh dup('$')
	
	; cursor
	cx_arr	dw	010Fh, 0E0Fh
	
	array_counter	dw	?
	
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
	
	call CLEAR_SCREEN
	
	; greeting
	mov ah, 09h
	lea dx, greet
	int 21h
	lea dx, NL
	int 21h

GET_INPUT:                    
	lea dx, _enter
	int 21h
	
	; user input
	mov ah, 01h
	int 21h
	sub al, 30h
	mov buffer, al
	
	; enter to continue
	mov ah,01h
	int 21h
	cmp al, 0Dh	; ENTER key
	je continue
	cmp al,1Bh	; ESC key
	je FIN_HOP
	jmp GET_INPUT 
	
continue:
	mov al, buffer
	; compare & select mode
	cmp al, 0
	jl ERROR_MSG	; input validation
	je EXIT_PROGRAM_HOP
	cmp al, 1
	je ONE_BYTE
	cmp al, 2
	je TWO_BYTE
	cmp al, 3
	je FOUR_BYTE
	cmp al, 4
	je EIGHT_BYTE
	cmp al, 5
	je TEN_BYTE
	jg ERROR_MSG	; input validation
	
FIN_HOP:
	jmp FIN
	
EXIT_PROGRAM_HOP:
	jmp EXIT_PROGRAM

ONE_BYTE:
	mov ah,09h
	lea dx,system_start
	int 21h
	
	call ONE_BYTE_STORE
	call PRINT_ARRAY
	jmp FIN

TWO_BYTE:
	mov ah,09h
	lea dx,system_start
	int 21h

	call TWO_BYTE_STORE
	call PRINT_ARRAY
	jmp FIN
	
FOUR_BYTE:
	mov ah,09h
	lea dx,system_start
	int 21h

	call FOUR_BYTE_STORE
	call PRINT_ARRAY
	jmp FIN
	
EIGHT_BYTE:
	mov ah,09h
	lea dx,system_start
	int 21h

	call EIGHT_BYTE_STORE
	call PRINT_ARRAY
	jmp FIN
	
TEN_BYTE:
	mov ah,09h
	lea dx,system_start
	int 21h

	call TEN_BYTE_STORE
	call PRINT_ARRAY
	jmp FIN

ERROR_MSG:
	mov ah, 09h
	lea dx, INVALID_MSG
	int 21h
	jmp GET_INPUT
	
FIN:
	; enter to continue
	mov ah,01h
	int 21h
	cmp al,1Bh	; ESC key
	je EXIT_PROGRAM
	cmp al,0Dh	; ENTER key
	je TO_MAIN_PROGRAM
	jmp ERROR_MSG

TO_MAIN_PROGRAM:
	mov ah,09h
	lea dx,NL
	int 21h
	lea dx,NL
	int 21h
	
	jmp MAIN

EXIT_PROGRAM:
	MOV AX, 4C00H
	INT 21H
MAIN ENDP

; =================================================
; ============== key in array =====================
; ====================== 
ONE_BYTE_STORE PROC
	call CLEAR_SCREEN
	push cx
	
	; array counter
	mov si, 0
	; cx as counter
	mov cx, 4
	
	one_byte_loop:
		
		; prompt enter
		mov ah, 09h
		lea dx, NL
		int 21h
		lea dx, _enter
		int 21h
		; user ENTER
		mov ah, 01h
		int 21h
		sub al, 30h
		mov one_byte_array[si], al
		
		; enter to continue
		mov ah, 01h 
		int 21h
		cmp al, 0Dh
		inc si	; add si, 1
		
		mov ah,09h
		lea dx,_enter_msg
		int 21h
		
		;hide CURSOR
		push cx           ; keep loop's cx counter
		mov ah,01h
		mov cx,2000h
		int 10h
		pop cx             
		
		; esc to exit
		mov ah,01h
		int 21h
		cmp al, 1Bh
		je END_LOOP_ONE_BYTE_STORE
		
		loop one_byte_loop
END_LOOP_ONE_BYTE_STORE:
	pop cx
	mov array_counter, si 	; store array counter
	ret
ONE_BYTE_STORE ENDP

; ====================== 
TWO_BYTE_STORE PROC
	call CLEAR_SCREEN
	push cx
	; array counter
	mov si, 0
	; cx as counter
	mov cx, 4
	
	two_byte_loop:
		
		; prompt enter
		mov ah, 09h
		lea dx, NL
		int 21h
		lea dx, _enter
		int 21h
		
		; user ENTER	input string AH=0Ah
		mov ah, 0Ah
		lea dx, two_byte_array_buffer
		int 21h
		
		mov ah,09h
		lea dx,NL
		int 21h
		
		; store two_byte_array_outputstring in two_byte_array[si]
		push cx			;store outter loop's cx
		mov cl, two_byte_array_buffer_actual_len
		mov ch, 0
		mov di, 0
		
		cmp cl, 0                        ; avoid infinity loop when cl = 0
		je skip_two_byte_copy 
		
		two_byte_array_copy_loop:
			mov al, two_byte_array_outputstring[di]
			mov bx, si		; bx get offset from [si+di]
			add bx, di
			mov byte ptr two_byte_array[bx], al		; define byte pointer to confirm in 2-byte only
			inc di
			loop two_byte_array_copy_loop
		
		skip_two_byte_copy:
		pop cx			; get back outter loop's cx
		
		add si, 2	; two byte per each
		
		mov ah,09h
		lea dx,_enter_msg
		int 21h
		
		;hide CURSOR
		push cx           ; keep loop's cx counter
		mov ah,01h
		mov cx,2000h
		int 10h
		pop cx  
		
		; esc to exit
		mov ah,01h
		int 21h
		cmp al, 1Bh
		je END_LOOP_TWO_BYTE_STORE
		
		loop two_byte_loop
END_LOOP_TWO_BYTE_STORE:
	pop cx
	mov array_counter, si 	; store array counter
	ret
TWO_BYTE_STORE ENDP	 

; ====================== 
FOUR_BYTE_STORE PROC
	call CLEAR_SCREEN
	push cx
	; array counter
	mov si, 0
	; cx as counter
	mov cx, 4
	four_byte_loop:
		
		; prompt enter
		mov ah, 09h
		lea dx, NL
		int 21h
		lea dx, _enter
		int 21h
		
		; user ENTER	input string AH=0Ah
		mov ah, 0Ah
		lea dx, four_byte_array_buffer
		int 21h
		
		mov ah,09h
		lea dx,NL
		int 21h
		
		; store four_byte_array_outputstring in four_byte_array[si]
		push cx			;store outter loop's cx
		mov cl, four_byte_array_buffer_actual_len
		mov ch, 0
		mov di, 0
		
		cmp cl, 0                        ; avoid infinity loop when cl = 0
		je skip_four_byte_copy 
		
		four_byte_array_copy_loop:
			mov al, four_byte_array_outputstring[di]
			mov bx, si		; bx get offset from [si+di]
			add bx, di
			mov byte ptr four_byte_array[bx], al		; define byte pointer to confirm in 2-byte only
			inc di
			loop four_byte_array_copy_loop
		
		skip_four_byte_copy:
		pop cx			; get back outter loop's cx
		
		
		add si, 4	; four byte per each
		
		mov ah,09h
		lea dx,_enter_msg
		int 21h
		
		;hide CURSOR
		push cx           ; keep loop's cx counter
		mov ah,01h
		mov cx,2000h
		int 10h
		pop cx  
		
		; esc to exit
		mov ah,01h
		int 21h
		cmp al, 1Bh
		je END_LOOP_FOUR_BYTE_STORE
		
		loop four_byte_loop
END_LOOP_FOUR_BYTE_STORE:
	pop cx
	mov array_counter, si  ; store array counter
	ret
FOUR_BYTE_STORE ENDP	

; ====================== 
EIGHT_BYTE_STORE PROC
	call CLEAR_SCREEN
	push cx
	; array counter
	mov si, 0
	; cx as counter
	mov cx, 4
	eight_byte_loop:
	
		; prompt enter
		mov ah, 09h
		lea dx, NL
		int 21h
		lea dx, _enter
		int 21h
		
		; user ENTER	input string AH=0Ah
		mov ah, 0Ah
		lea dx, eight_byte_array_buffer
		int 21h
		
		mov ah,09h
		lea dx,NL
		int 21h
		
		; store eight_byte_array_outputstring in eight_byte_array[si]
		push cx			;store outter loop's cx
		mov cl, eight_byte_array_buffer_actual_len
		mov ch, 0
		mov di, 0
		
		cmp cl, 0                        ; avoid infinity loop when cl = 0
		je skip_eight_byte_copy 
		
		eight_byte_array_copy_loop:
			mov al, eight_byte_array_outputstring[di]
			mov bx, si		; bx get offset from [si+di]
			add bx, di
			mov byte ptr eight_byte_array[bx], al		; define byte pointer to confirm in 2-byte only
			inc di
			loop eight_byte_array_copy_loop
		
		skip_eight_byte_copy:
		pop cx			; get back outter loop's cx
		
		
		add si, 8	; eight byte per each
		
		mov ah,09h
		lea dx,_enter_msg
		int 21h
		
		;hide CURSOR
		push cx           ; keep loop's cx counter
		mov ah,01h
		mov cx,2000h
		int 10h
		pop cx  
		
		; esc to exit
		mov ah,01h
		int 21h
		cmp al, 1Bh
		je END_LOOP_EIGHT_BYTE_STORE
		
		loop eight_byte_loop
END_LOOP_EIGHT_BYTE_STORE:
	pop cx
	mov array_counter, si 	; store array counter
	ret
EIGHT_BYTE_STORE ENDP	 

; ====================== 
TEN_BYTE_STORE PROC
	call CLEAR_SCREEN
	push cx
	; array counter
	mov si, 0
	; cx as counter
	mov cx, 4
	ten_byte_loop:	
		
		; prompt enter
		mov ah, 09h
		lea dx, NL
		int 21h
		lea dx, _enter
		int 21h
		
		; user ENTER	input string AH=0Ah
		mov ah, 0Ah
		lea dx, ten_byte_array_buffer
		int 21h
		
		mov ah,09h
		lea dx,NL
		int 21h
		
		; store ten_byte_array_outputstring in ten_byte_array[si]
		push cx			;store outter loop's cx
		mov cl, ten_byte_array_buffer_actual_len
		mov ch, 0
		mov di, 0
		
		cmp cl, 0                        ; avoid infinity loop when cl = 0
		je skip_ten_byte_copy 
		
		ten_byte_array_copy_loop:
			mov al, ten_byte_array_outputstring[di]
			mov bx, si		; bx get offset from [si+di]
			add bx, di
			mov byte ptr ten_byte_array[bx], al		; define byte pointer to confirm in 2-byte only
			inc di
			loop ten_byte_array_copy_loop
		
		skip_ten_byte_copy:
		pop cx			; get back outter loop's cx
		
		
		add si, 10	; ten byte per each
		
		mov ah,09h
		lea dx,_enter_msg
		int 21h
		
		;hide CURSOR
		push cx           ; keep loop's cx counter
		mov ah,01h
		mov cx,2000h
		int 10h
		pop cx  
		
		; esc to exit
		mov ah,01h
		int 21h
		cmp al, 1Bh
		je END_LOOP_TEN_BYTE_STORE
		
		loop ten_byte_loop
END_LOOP_TEN_BYTE_STORE:
	pop cx
	mov array_counter, si 	; store array counter
	ret
TEN_BYTE_STORE ENDP

; =================================================
; =============== print array =====================
PRINT_ARRAY PROC
	
	push ax
	push dx
	
	lea dx,NL
	int 21h
	mov ah,09h
	lea dx,printer_msg
	int 21h
	lea dx,NL
	int 21h
	
	pop ax
	pop dx
	
	mov array_counter, si 	; get array counter state
	cmp si, 40	; 4(10)
	jl CHECK_IN_EIGHT_BYTE
	call PRINT_TEN
	jmp RETURN
	
CHECK_IN_EIGHT_BYTE:
	cmp si, 32	; 4(8)
	jl CHECK_IN_FOUR_BYTE
	call PRINT_EIGHT
	jmp RETURN

CHECK_IN_FOUR_BYTE:	
	cmp si, 16	; 4(4)
	jl CHECK_IN_TWO_BYTE
	call PRINT_FOUR
	jmp RETURN
	
CHECK_IN_TWO_BYTE:
	cmp si, 8	; 4(2)
	jl CHECK_IN_ONE_BYTE
	call PRINT_TWO
	jmp RETURN
	
CHECK_IN_ONE_BYTE:
	cmp si, 4	; 4(1)
	call PRINT_ONE
	jmp RETURN
	
RETURN:
	mov ah,09h
	lea dx,NL
	int 21h
	lea dx,NL
	int 21h
	lea dx,_return_str
	int 21h
	lea dx,NL
	int 21h
	lea dx,_exit_str
	int 21h
	
	; hide CURSOR
	mov ah,01h
	mov cx,2000h
	int 10h

	ret
PRINT_ARRAY ENDP

PRINT_ONE PROC
	; renew counter state
	mov cx,one_byte_array_len
	mov si, 0
	
	
	LOOP_PRINT_ONE:
		
		mov ah,02h
		mov dl,' '
		int 21h
		
		mov ah,02h
		mov dl, one_byte_array[si]
		add dl, 30h		
		int 21h
		
		inc si
		
		loop LOOP_PRINT_ONE
	ret
PRINT_ONE ENDP

PRINT_TWO PROC
	; renew counter state
	mov cx,two_byte_array_len
	mov si, 0
	
	LOOP_PRINT_TWO:

		mov ah,02h
		mov dl,' '
		int 21h
		
		push cx              ; store outer loop's cx counter
		mov cx, 2            ; each str max 2 char
		mov di, 0
		
	PRINT_TWO_INNER:
		mov ah,02h
		mov bx, si
		add bx, di
		mov dl, byte ptr two_byte_array[bx]
		int 21h
		inc di
		loop PRINT_TWO_INNER
		pop cx               
		
		add si, 2
		
		loop LOOP_PRINT_TWO
	ret
PRINT_TWO ENDP

PRINT_FOUR PROC
	; renew counter state
	mov cx,four_byte_array_len
	mov si, 0
	
	LOOP_PRINT_FOUR:

		mov ah,02h
		mov dl,' '
		int 21h
		
		push cx              ; store outer loop's cx counter
		mov cx, 4            ; each str max 4 char
		mov di, 0
		
	PRINT_FOUR_INNER:
		mov ah,02h
		mov bx, si
		add bx, di
		mov dl, byte ptr four_byte_array[bx]
		int 21h
		inc di
		loop PRINT_FOUR_INNER
		pop cx   
		
		add si, 4
		
		loop LOOP_PRINT_FOUR
	ret
PRINT_FOUR ENDP

PRINT_EIGHT PROC
	; renew counter state
	mov cx,eight_byte_array_len
	mov si, 0

	LOOP_PRINT_EIGHT:
	
		mov ah,02h
		mov dl,' '
		int 21h
		
		push cx              ; store outer loop's cx counter
		mov cx, 8            ; each str max 8 char
		mov di, 0
		
	PRINT_EIGHT_INNER:
		mov ah,02h
		mov bx, si
		add bx, di
		mov dl, byte ptr eight_byte_array[bx]
		int 21h
		inc di
		loop PRINT_EIGHT_INNER
		pop cx 
		
		add si, 8
		
		loop LOOP_PRINT_EIGHT
	ret
PRINT_EIGHT ENDP

PRINT_TEN PROC
	; renew counter state
	mov cx,ten_byte_array_len
	mov si, 0

	LOOP_PRINT_TEN:
	
		mov ah,02h
		mov dl,' '
		int 21h
		
		push cx              ; store outer loop's cx counter
		mov cx, 10            ; each str max 10 char
		mov di, 0
		
	PRINT_TEN_INNER:
		mov ah,02h
		mov bx, si
		add bx, di
		mov dl, byte ptr ten_byte_array[bx]
		int 21h
		inc di
		loop PRINT_TEN_INNER
		pop cx 
		
		add si, 10
		
		loop LOOP_PRINT_TEN
	ret
PRINT_TEN ENDP

CLEAR_SCREEN PROC
	; clear window
	mov ah, 06h
	mov al, 00h     ; whole screen  
	mov bh, 07h     ; black + white
	mov cx, 0000h   ; ch = 00h   cl = 00h
	mov dx, 184Fh   ; dh = 18h   dl = 4fh
	int 10h			; 80*25 px
	
	; reset cursor
	mov ah, 02h
	mov bh, 00h        ; first page
	mov dx, 0000h      ; row = 0    col = 0
	int 10h
	ret
CLEAR_SCREEN ENDP

END MAIN
