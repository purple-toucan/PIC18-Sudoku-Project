#include p18f87k22.inc
;
	extern Set_GLCD_Cursor_X, Set_GLCD_Cursor_Y
	extern Write_Block_2
	
	global write_correct, write_wrong
	
Storage	code    ; a section of programme memory for storing data
	; ******* myTable, data in programme memory, and its length *****
C_PM data 0x38,0x44,0x44,0x28
	constant    C_length = 4
O_PM data 0x38,0x44,0x44,0x38
	constant    O_length = 4
R_PM data 0x7C,0x14,0x34,0x48
	constant    R_length = 4
E_PM data 0x7C,0x54,0x54,0x44
	constant    E_length = 4
T_PM data 0x04,0x04,0x7C,0x04,0x04
	constant    T_length = 5
	
E_Mark_PM data 0x17
	constant    E_Mark_length = 1
	
W_PM data 0x7C,0x20,0x10,0x20,0x7C
	constant    W_length = 5
N_PM data 0x7C,0x08,0x10,0x7C
	constant    N_length = 4
G_PM data 0x38,0x44,0x54,0x30
	constant    G_length = 4
	
Tables2	udata_acs    ; reserve data anywhere in RAM (here at 0x400)
counter res 1
	
Tables2	udata	0x300    ; reserve data anywhere in RAM (here at 0x400)
row_message	res .64
	
Main	code
	
write_correct
	movlw	0x03
	call	Set_GLCD_Cursor_X
	movlw	0x00
	call	Set_GLCD_Cursor_Y
	
	lfsr	2, row_message
	
	movlw	.13
	call	w_padding
	
	movlw	upper(C_PM)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(C_PM)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(C_PM)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	C_length	; bytes to read
	call	load_letter
	
	movlw	0x00
	movwf	POSTINC2
	
	movlw	upper(O_PM)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(O_PM)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(O_PM)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	O_length	; bytes to read
	call	load_letter
	
	movlw	0x00
	movwf	POSTINC2
	
	movlw	upper(R_PM)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(R_PM)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(R_PM)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	R_length	; bytes to read
	call	load_letter
	
	movlw	0x00
	movwf	POSTINC2
	
	movlw	upper(R_PM)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(R_PM)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(R_PM)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	R_length	; bytes to read
	call	load_letter
	
	movlw	0x00
	movwf	POSTINC2
	
	movlw	upper(E_PM)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(E_PM)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(E_PM)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	E_length	; bytes to read
	call	load_letter
	
	movlw	0x00
	movwf	POSTINC2
	
	movlw	upper(C_PM)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(C_PM)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(C_PM)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	C_length	; bytes to read
	call	load_letter
	
	movlw	0x00
	movwf	POSTINC2
	
	movlw	upper(T_PM)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(T_PM)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(T_PM)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	T_length	; bytes to read
	call	load_letter
	
	movlw	0x00
	movwf	POSTINC2
	
	movlw	upper(E_Mark_PM)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(E_Mark_PM)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(E_Mark_PM)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	E_Mark_length	; bytes to read
	call	load_letter
	
	movlw	.13
	call	w_padding
	
	lfsr	2, row_message
	call	Write_Block_2
	
	return
	
write_wrong
	
	movlw	0x03
	call	Set_GLCD_Cursor_X
	movlw	0x00
	call	Set_GLCD_Cursor_Y
	
	lfsr	2, row_message
	
	movlw	.18
	call	w_padding
	
	movlw	upper(W_PM)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(W_PM)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(W_PM)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	W_length	; bytes to read
	call	load_letter
	
	movlw	0x00
	movwf	POSTINC2
	
	movlw	upper(R_PM)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(R_PM)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(R_PM)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	R_length	; bytes to read
	call	load_letter
	
	movlw	0x00
	movwf	POSTINC2
	
	movlw	upper(O_PM)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(O_PM)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(O_PM)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	O_length	; bytes to read
	call	load_letter
	
	movlw	0x00
	movwf	POSTINC2
	
	movlw	upper(N_PM)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(N_PM)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(N_PM)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	N_length	; bytes to read
	call	load_letter
	
	movlw	0x00
	movwf	POSTINC2
	
	movlw	upper(G_PM)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(G_PM)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(G_PM)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	G_length	; bytes to read
	call	load_letter
	
	movlw	0x00
	movwf	POSTINC2
	
	movlw	upper(E_Mark_PM)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(E_Mark_PM)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(E_Mark_PM)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	E_Mark_length	; bytes to read
	call	load_letter
	
	
	movlw	.18
	call	w_padding
	
	lfsr	2, row_message
	call	Write_Block_2
	
	return
	
w_padding   ; Pad FSP2 with W number of 0x00 bytes
	movwf	counter
wplp
	movlw	0x00
	movwf	POSTINC2
	decfsz	counter
	bra	wplp
	return
	
load_letter
	movwf 	counter	; our counter register
lllp 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC2; move data from TABLAT to (FSR2), inc FSR2
	decfsz	counter	; count down to zero
	bra	lllp		; keep going until finished
	return

	end