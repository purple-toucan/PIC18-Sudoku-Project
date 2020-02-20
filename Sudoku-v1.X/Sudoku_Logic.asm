	#include p18f87k22.inc

	extern write_cursor
		
	global	cursor_x, cursor_y
	global	sudoku_brdplayer
	global	update_game
	
	
	
reserve code
	
acs0	    udata_acs   ; reserve data space in access ram	
cursor_x    res 1 ;reserve memory space for global cursor variable
cursor_y    res	1
W_in	    res 1 ; reserve memory space variable for W input
UP	    res 1   ;	UP command
DOWN	    res 1   ; DOWN command
RIGHT	    res 1   ; RIGHT command
LEFT	    res 1   ; LEFT command
FIXED	    res 1   ; reserved for testing if cursor fixed
	    
Boards	udata	0x600 ;reserve data space for boards in bank 6
sudoku_brdplayer res 81	;sudoku board the player is working on 
sudoku_brdsolution  res 81  ;sudoku board full of solutions
sudoku_brdfixedp    res 81  ;sudoku board fixed points

main	code

sudoku_lsetup	; sets values for arrows
    movlw   0x41
    movwf   UP

    movlw   0x43
    movwf   DOWN
    
    movlw   0x42
    movwf   RIGHT
    
    movlw   0x44
    movwf   LEFT
    
    
update_game ;	handles arrow and error controls
    movwf   W_in ;  moves w to W_in
    btfsc   W_in, 6 ;	skips next line if bit 6 of W_in is clear
    bra	arrow_con   ;	branches to arrow control if set
    bra	curs_fix    ;	branches to cursor fixing if clear
    
arrow_con   ;	arrow command controls
    cpfseq  UP	;   compare wreg to up command
    bra Down	; pass branch to down
    bra go_up
Down
    cpfseq  DOWN ; compare wreg to down. skip if =
    bra Right	
    bra go_down
Right
    cpfseq  RIGHT
    bra Left
    bra go_right
Left
    cpfseq  LEFT
    nop
    bra go_left
    
end_return
    return

go_up
    movlw   0x00
    cpfseq  cursor_x ;	check if cursor is at boundary
    bra end_return
    call    write_cursor
    decf    cursor_x, f ; move cursor
    
    bra end_return
    
go_down
    movlw   0x08
    cpfseq  cursor_x ;	check if cursor is at boundary
    bra end_return
    call    write_cursor
    incf    cursor_x, f
    
    bra end_return
    
go_right
    movlw   0x08
    cpfseq  cursor_y ;	check if cursor is at boundary
    bra	end_return
    call    write_cursor
    incf    cursor_y, f
    
    bra end_return

go_left
    movlw   0x00
    cpfseq  cursor_y ;	check if cursor is at boundary
    bra end_return
    call    write_cursor
    incf    cursor_y, f
    
    bra end_return
    
curs_fix    ;	determining if cursor is fixed or not
    lfsr    0, sudoku_brdfixedp	;   loading fixed position sudoku onto FSR0
    
    movlw   0x09
    mulwf   cursor_x	;   multiply x pos by 9
    
    movf    cursor_y, w
    addwf   PRODL, w	;   offset is now loaded into wreg    
    
    movf    PLUSW0, w
    movwf   FIXED    ;	load TEST location with w
    tstfsz  FIXED    ;	skips if location of cursor in fixed board is 0
    return
    lfsr    0, sudoku_brdplayer	;   loading player board onto FSR0
    
    movlw   0x09
    mulwf   cursor_x	
    
    movf    cursor_y, w
    addwf   PRODL, w	;   offset is now loaded into wreg    
    
    movff   W_in, PLUSW0    ;	changing value of cursor cell on player board
    
    call    Write_Cursor	; calling to realise cursor action
    
    
    return  

    end