#include p18f87k22.inc
    
    global  Create_Board
    
    extern Draw_Grid
    extern Write_Cell
    extern number_name
    extern sudoku_y, sudoku_x
    extern sudoku_brdplayer, sudoku_brdsolution
    extern sudoku_brdfixedp
    
    constant board_length = .81
	
vars	udata_acs    ; reserve data anywhere in RAM (here at 0x400)
counter res 1
 
main	code
	
Create_Board
	call	Draw_Grid
	
	lfsr	0, sudoku_brdplayer
	movlw	board_length
	movwf	counter
	movlw	0x00
pllp
	movwf	POSTINC0
	decfsz	counter
	bra	pllp
	
	lfsr	0, sudoku_brdsolution
	movlw	board_length
	movwf	counter
	movlw	0x00
sllp
	movwf	POSTINC0
	decfsz	counter
	bra	sllp
	
	lfsr	0, sudoku_brdfixedp
	movlw	board_length
	movwf	counter
	movlw	0x00
fplp
	movwf	POSTINC0
	decfsz	counter
	bra	fplp
	
	return
    end


