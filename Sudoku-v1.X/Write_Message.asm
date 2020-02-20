#include p18f87k22.inc
;
	extern Set_GLCD_Cursor_X, Set_GLCD_Cursor_Y
	extern Write_Block_2
	

;	
;	
;Storage	code    ; a section of programme memory for storing data
;	; ******* myTable, data in programme memory, and its length *****
;Y_Table_PM  data .3,.9,.15,.23,.29,.35,.43,.49,.55
;	    ; y adress (on GLCD) of left side pixel of 5x5 sudoku cell
;	    ; for sudoku columns 0-8
;	    constant    Y_Table_length = 9
;	    
;;X_Table_PM  data 0,1,1,2,3,4,5,6,6, 5,5,1,1,3,5,5,5,1, 3,1,7,7,5,3,3,1,7
;X_Table_PM  data .0,.1,.1,.2,.3,.4,.5,.6,.6, .5,.5,.1,.1,.3,.5,.5,.5,.1, .3,.1,.7,.7,.5,.3,.3,.1,.7
;	    ; x adress (row on GLCD) of top part of 5x5 sudoku cell
;	    ; how many pixel rows are there of 5x5 shape in this upper row
;	    ; upoccupied pixel rows above 5x5 cell in upper row
;	    ; for suduko rows 0-8, 0-8, 0-8
;	    constant    X_Table_length = 27
;	    
;;X_UMask_Table_PM  data 0xE0,0x83,0xFE, 0xFE,0xF8,0xE0, 0xE0,0x83,0xFE
;X_UMask_Table_PM  data 0x07,0xC1,0x7F, 0x7F,0x1F,0x07, 0x07,0xC1,0x7F
;	    ; data masks for upper part of 5x5 cells
;	    ; for suduko rows 0-8
;	    constant    X_UMask_Table_length = 9
;	    
;;X_LMask_Table_PM  data 0xFF,0xFF,0x0F, 0x0F,0x3F,0x00, 0xFF,0xFF,0x0F
;X_LMask_Table_PM  data 0xFF,0xFF,0xF0, 0xF0,0xFC,0xFF, 0xFF,0xFF,0xF0
;	    ; data masks for lower part of 5x5 cells
;	    ; for suduko rows 0-8
;	    constant    X_LMask_Table_length = 9
;	    
;;Shapes_PM   data 0,0,0,0,0, 0,0x40,0x7C,0,0, 0xB8,0xA8,0xA8,0xA8,0xE8, 0x88,0x88,0xA8,0xA8,0xF8, 0xE0,0x20,0x20,0x20,0xF8 ,0xE8,0xA8,0xA8,0xA8,0xB8, 0xF8,0xA8,0xA8,0xA8,0xB8, 0x80,0x80,0x98,0xA0,0xC0, 0xF8,0xA8,0xA8,0xA8,0xF8, 0xE8,0xA8,0xA8,0xA8,0xF8
;Shapes_PM1   data    0x00,0x00,0x00,0x00,0x00, 0x00,0x12,0x1F,0x10,0x00, 0x1D,0x15,0x15,0x15,0x17, 0x11,0x11,0x15,0x15,0x1F, 0x07,0x04,0x04,0x04,0x1F, 0x17,0x15,0x15,0x15,0x1D
;Shapes_PM2   data    0x1F,0x15,0x15,0x15,0x1D, 0x01,0x01,0x19,0x05,0x03, 0x1F,0x15,0x15,0x15,0x1F, 0x17,0x15,0x15,0x15,0x1F, 0x1F,0x1F,0x1F,0x1F,0x1F
;   ; 5 bytes of storage for shape paterns for each digit 0-9 and one solid block
;	    constant	Shape_Table1_length = 30
;	    constant	Shape_Table2_length = 25
;   
;Tables	udata	0x400    ; reserve data anywhere in RAM (here at 0x400)
;Y_Table		res Y_Table_length    ; reserve 9 bytes for Column Look Up Table
;X_Table		res X_Table_length	; reserve 27 bytes for Row Look Up Table
;X_UMask_Table	res X_UMask_Table_length ; Mask storage
;X_LMask_Table	res X_LMask_Table_length ; Mask storage
;
;Tables2	udata	0x500    ; reserve data anywhere in RAM (here at 0x400)
;Shapes_Table	res Shape_Table1_length + Shape_Table2_length
;	
;acs0	    udata_acs
;number_name res 1   ; Variables to be accessed from external programs
;sudoku_x    res 1   ; sudoku coordinate of cell
;sudoku_y    res 1   ; sudoku coordinate of cell
;w_input	    res 1
; 
;Reading_Counter	res 1	
;tlp_x		res 1	; x-pixel coordinate value of top left of 5x5 cell
;tlp_y		res 1	; y-pixel coordinate value of top left of 5x5 cell
;mask		res 1
;rotate_counter	res 1
;	
;read_data	res 5
;shifted_shape	res 5
;	
;counter		res 1
;	
	
Tables2	udata	0x300    ; reserve data anywhere in RAM (here at 0x400)
;correct_PM	res .38
;wrong_PM	res .28
row_message	res .64
	
Main	code
	
write_correct
	movlw	0x03
	call	Set_GLCD_Cursor_X
	movlw	0x00
	call	Set_GLCD_Cursor_Y
	
	lfsr	
	call	Write_Block_2
	
	return
	
write_wrong
	
	return

	end