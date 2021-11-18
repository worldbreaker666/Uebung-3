; rdi: pointer to str -> holds an address to data! -> [rdi]
; rsi: base of str number -> input is only 8bit -> only use lower 8 bits -> sil

	global strToInt

strToInt:
	PUSH	rbx		; save rbx
	XOR	rax, rax	; zero accu register
	XOR	r9, r9		; zero temp result register
	XOR	rdx, rdx	; zero next byte register
	XOR	rbx, rbx	; zero len register
	CALL	get_len
	MOV	rbx, rax	; store len
	XOR	rcx, rcx	; zero counter register
loop_begin:
	MOV	dl, [rdi+rcx]	; load 8bit from location described by rdi
	CMP	dl, 0		; strings are zero/null-terminated
	JE	loop_end
	DEC	rbx		; reduce len every loop
	PUSH	rdx		; save byte of string
	PUSH	rdi		; save string
	PUSH	rsi		; save base
	MOV	rdi, rsi	; set base as first arg for power_of
	MOV	rsi, rbx	; set len as second arg for power_of
	CALL	power_of	; call: base ^ len
	MOV	r8, rax		; store result in r8
	POP	rsi		; restore base
	POP	rdi		; restore string
	POP	rdx		; restore byte of string
	XOR	rax, rax	; zero rax t obe sure
	CMP	dl, 65		; read byte >= 65?
	JL	digit
	SUB	dl, 55		; make sense of letters
	JMP cont
digit:
	SUB	dl, 48		; subtract offset of 48 (ASCII), digits
cont:
	MOV	al, dl		; store read byte in accu
	MUL	r8		; multiply with base ^ len
	ADD	r9, rax		; add generated number to result
	INC	rcx		; increment counter by 1 byte
	JMP	loop_begin
loop_end:
	MOV	rax, r9		; finally move result to rax
	POP	rbx		; restore rbx
	RET			; and return result

; rdi: pointer to string
get_len:
	XOR	rcx, rcx	; zero counter
gllb:
	MOV	dl, [rdi+rcx]	; load 8bit from location described by rdi
	CMP	dl, 0		; strings are zero/null-terminated
	JE	glle
	ADD	rcx, 1		; increment counter by 1 byte
	JMP	gllb
glle:
	MOV	rax, rcx	; return str len
	RET


; rdi: base
; rsi: exponent
power_of:
	MOV	rax, 1
	MOV	r10, rdi
polb:
	CMP	rsi, 0
	JE	pole
	MUL	r10
	DEC	rsi
	JMP	polb
pole:
	RET
