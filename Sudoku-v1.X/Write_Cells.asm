#include p18f87k22.inc


Storage	code    ; a section of programme memory for storing data
	; ******* myTable, data in programme memory, and its length *****
Y_Table_PM  data 3,9,15,23,29,35,43,39
	    ; y adress (on GLCD) of left side pixel of 5x5 sudoku cell
	    ; for sudoku columns 0-8
	    constant    Y_Table_length = 9
	    
X_Table_PM  data 0,1,1,2,3,4,5,6,6, 5,5,1,1,3,5,5,5,1, 3,1,7,7,5,3,3,1,7
	    ; x adress (row on GLCD) of top part of 5x5 sudoku cell
	    ; how many pixel rows are there of 5x5 shape in this upper row
	    ; upoccupied pixel rows above 5x5 cell in upper row
	    ; for suduko rows 0-8, 0-8, 0-8
	    constant    X_Table_length = 27
	    
X_UMask_Table_PM  data 0xE0,0x83,0xFE, 0xFE,0xF8,0xE0, 0xE0,0x83,0xFE
	    ; data masks for upper part of 5x5 cells
	    ; for suduko rows 0-8
	    constant    X_UMask_Table_length = 9
	    
X_LMask_Table_PM  data 0xFF,0xFF,0x0F, 0x0F,0x3F,0x00, 0xFF,0xFF,0x0F
	    ; data masks for lower part of 5x5 cells
	    ; for suduko rows 0-8
	    constant    X_LMask_Table_length = 9
	    
Shapes_PM   data 0,0,0,0,0, 0,0x40,0x7C,0,0, 0xB8,0xA8,0xA8,0xA8,0xE8, 0x88,0x88,0xA8,0xA8,0xF8, 0xE0,0x20,0x20,0x20,0xF8 ,0xE8,0xA8,0xA8,0xA8,0xB8, 0xF8,0xA8,0xA8,0xA8,0xB8, 0x80,0x80,0x98,0xA0,0xC0, 0xF8,0xA8,0xA8,0xA8,0xF8, 0xE8,0xA8,0xA8,0xA8,0xF8
	    ; 5 bytes of storage for shape paterns for each digit 0-9
	    constant	Shape_Table_length = 50
   
Tables	udata	0x400    ; reserve data anywhere in RAM (here at 0x400)
Reading_Counter	res 0x1
Y_Table		res Y_Table_length    ; reserve 9 bytes for Column Look Up Table
X_Table		res X_Table_length	; reserve 27 bytes for Row Look Up Table
X_UMask_Table	res X_UMask_Table_length ; Mask storage
X_LMask_Table	res X_LMask_Table_length ; Mask storage
Shapes_Table	res Shape_Table_length


Main	code
 
Write_Cells_Setup
	bcf	EECON1, CFGS	;Allow Reading in from PM
	bsf	EECON1, EEPGD 	
	
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Read In Y Look Up Table From PM to RAM
	
	lfsr	FSR0, Y_Table	; Load FSR0 with address in RAM	
	movlw	upper(Y_Table_PM)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(Y_Table_PM)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(Y_Table_PM)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	Y_Table_length	; bytes to read
	movwf 	Reading_Counter	; our counter register
Yrdlp 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	Reading_Counter	; count down to zero
	bra	Yrdlp		; keep going until finished	
	
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Read In X Look Up Table From PM to RAM
	
	lfsr	FSR0, X_Table	; Load FSR0 with address in RAM	
	movlw	upper(X_Table_PM)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(X_Table_PM)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(X_Table_PM)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	X_Table_length	; bytes to read
	movwf 	Reading_Counter	; our counter register
Xrdlp 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	Reading_Counter	; count down to zero
	bra	Xrdlp		; keep going until finished	
	
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Read in Data Mask Tables From PM to RAM
	
	lfsr	FSR0, X_UMask_Table	; Load FSR0 with address in RAM	
	movlw	upper(X_UMask_Table_PM)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(X_UMask_Table_PM)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(X_UMask_Table_PM)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	X_UMask_Table_length	; bytes to read
	movwf 	Reading_Counter	; our counter register
UMrdlp 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	Reading_Counter	; count down to zero
	bra	UMrdlp		; keep going until finished	
	
	lfsr	FSR0, X_LMask_Table	; Load FSR0 with address in RAM	
	movlw	upper(X_LMask_Table_PM)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(X_LMask_Table_PM)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(X_LMask_Table_PM)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	X_LMask_Table_length	; bytes to read
	movwf 	Reading_Counter	; our counter register
LMrdlp 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	Reading_Counter	; count down to zero
	bra	LMrdlp		; keep going until finished	

	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Read In Shape Look Up Table From PM to RAM
	
	lfsr	FSR0, Shapes_Table	; Load FSR0 with address in RAM	
	movlw	upper(Shapes_PM)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(Shapes_PM)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(Shapes_PM)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	Shape_Table_length	; bytes to read
	movwf 	Reading_Counter	; our counter register
Srdlp 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	Reading_Counter	; count down to zero
	bra	Srdlp		; keep going until finished	
	return
	
	
	end