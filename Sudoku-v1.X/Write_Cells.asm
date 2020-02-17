#include p18f87k22.inc

	extern Set_Cursor_X, Set_Cursor_Y
	extern Write_Block, Read_Block
	
	global Write_Cell, Write_Cells_Setup
;	global number_name, invert_flag
;	global sudoku_x, sudoku_y
	
	
Storage	code    ; a section of programme memory for storing data
	; ******* myTable, data in programme memory, and its length *****
;Y_Table_PM  data 3,9,15,23,29,35,43,39
Y_Table_PM  data 73,11,15,24,24,35,43,39
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
Y_Table		res Y_Table_length    ; reserve 9 bytes for Column Look Up Table
X_Table		res X_Table_length	; reserve 27 bytes for Row Look Up Table
X_UMask_Table	res X_UMask_Table_length ; Mask storage
X_LMask_Table	res X_LMask_Table_length ; Mask storage
Shapes_Table	res Shape_Table_length
	
acs0	    udata_acs
number_name res 1   ; Variables to be accessed from external programs
sudoku_x    res 1   ; sudoku coordinate of cell
sudoku_y    res 1   ; sudoku coordinate of cell
invert_flag res 1   ; invert cell colours?
 
Reading_Counter	res 1	
tlp_x		res 1	; x-pixel coordinate value of top left of 5x5 cell
tlp_y		res 1	; y-pixel coordinate value of top left of 5x5 cell
mask		res 1
rotate_counter	res 1
	
read_data	res 5
shifted_shape	res 5
	
counter		res 1
	

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
	movwf 	Reading_Counter	; counter register
Yrdlp 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
;	movf	TABLAT, w
;	movwf	POSTINC0
	movff	TABLAT, FSR0; move data from TABLAT to (FSR0), inc FSR0	
	
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
	
	
Write_Cell
	
	movlw	0x00
	movwf	sudoku_x
	movlw	0x00
	movwf	sudoku_y
	movlw	0x05
	movwf	number_name
	
	movf	sudoku_y, w	; Index y-look up table with sudoku_y 
	lfsr	FSR0, Y_Table	; to find tlp_y
	movff	PLUSW0, tlp_y
	movf	sudoku_x, w	; Index x-look up table with sudoku_x 
	lfsr	FSR0, X_Table	; to find tlp_x
	movff	PLUSW0, tlp_x
	lfsr	FSR0, X_UMask_Table	; to find upper mask
	movff	PLUSW0, mask
	
	movf	tlp_x, w
	call	Set_Cursor_X
	movf	tlp_y, w
	call	Set_Cursor_Y	; Move Cursor to Target Cell
	lfsr	FSR2, read_data
	movlw	0x05		; Target Cell is of Length 5
	call	Read_Block	; Read Current State of Target Cell to read_data
	
	movlw	0x05
	movwf	counter		    ; Shape is 5 long
	lfsr	FSR1, shifted_shape ; Destination
	lfsr	FSR0, Shapes_Table  ; Source - up-table
	movlw	0x05
	mulwf	number_name
	movf	PRODL, w	; Create Index for Begining of Relevant Shape
idlp	movff	PLUSW0, POSTINC1
	addlw	0x01
	decfsz	counter
	bra	idlp		; Shape is read into shifted_shape
	
	lfsr	FSR0, X_Table
	movf	sudoku_x, w	; Index x-look up table with sudoku_x 
	addlw	0x18		; Access Same Row, Third column of look up table
	movff	PLUSW0, rotate_counter
rtlp	movlw	0x05
	movwf	counter		; Column Counter
	lfsr	FSR1, shifted_shape
sslp	addlw	0x00		; Clear Carry Bit
	rlcf	POSTINC1, f	; Rotate through carry
	decfsz	counter
	bra	sslp
	decfsz	rotate_counter	; At least 1 rotation is always requiered
	bra	rtlp		; Shifted Shape Data now stored at shifted_shape
	
	movlw	0x05
	movwf	counter
	lfsr	FSR2, read_data
	lfsr	FSR1, shifted_shape
cmlp	movf	mask, w
	andwf	FSR2, f		; Apply Mask to Data
	movf	POSTINC1, w
	addwf	POSTINC2, f	; Add in shape data 
	decfsz	counter
	bra	cmlp		; Upper shape data is now at read_data and ready
	
	movf	tlp_y, w
	call	Set_Cursor_Y	; Move Cursor to Target Cell
	lfsr	FSR2, read_data
	movlw	0x05		; Target Cell is of Length 5
	call	Write_Block	; Read Current State of Target Cell to read_data
	
	
	return
	
	
	end