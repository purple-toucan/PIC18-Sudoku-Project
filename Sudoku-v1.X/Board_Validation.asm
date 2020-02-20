	#include p18f87k22.inc
	extern sudoku_brdplayer
	extern sudoku_brdsolution
	
	global validate
	
	
reserve	code	

	
acs0	    udata_acs   ; reserve data space in access ram	
counter	    res 1   ;	reserved for counter
	    
main code
validate
    movlw	0x51
    movwf	counter	;   setting counter to 81

    lfsr	0, sudoku_brdplayer    ;	player board loading into FFSR0

not_full
    movlw   0x00
    return
    
invalid
    movlw   0x01
    return
    
loop1
    tstfsz  POSTINC0	;   tests elements, skips if cell empty
    decfsz  counter ;	decrement counter by 1 for each cell
    bra	    not_full
    bra	    loop1    ;	completes loop


    movlw   0x51
    movwf   counter ;	setting counter to 81
    
    lfsr    0,	sudoku_brdplayer    ;	player board loading onto FSR0
    lfsr    1,	sudoku_brdsolution  ;	solution board loading onto FSR1
    
loop2
    movf    POSTINC0, w	    ;   move cell into wreg for comparison
    cpfseq  POSTINC1	;   skips if both cells are in agreement
    bra	    invalid	;   branch to invalid subroutine
    decfsz  counter ;	decrement counter
    bra	    loop2

    movlw	0x02	;   set w to 2
    return
    
    end