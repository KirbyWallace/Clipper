/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Clr( nLine, nCol, nToLine, nToCol ) --> NIL

PARAMETERS:

nLine   : box coordinates
nCol    : "" ""
nToLine : "" ""
nToCol  : "" ""

SHORT:

Clear a screen, region of a screen, line, or portion of a line.

DESCRIPTION:

k_Clr() Clears the screen, a line, or a screen area, depending on how 
the parameters are used.

One Parameter   : nLine cleared
Two Parameters  : nLine cleared from nCol to end of nLine
Three Parameters: Screen cleared from nLine,nCol to end of nToLine
Four Parameters : Screen cleared from nLine,nCol to nToLine,nToCol

No Parameters   : Entire screen cleared

NOTE:



EXAMPLE:

k_Clr()           // screen cleared
k_Clr(17)         // line 17 cleared, rest of screen left
k_Clr(5,10,15,70) // region of screen cleared inside box coordinates.

******************************************************************************/

FUNCTION k_Clr(nLine,nCol,nToLine,nToCol)

if pcount() = 0
    CLEAR SCREEN
else
    if pcount() = 1
        @ nLine,00 clear to nLine,MaxCol()
    else
        if pcount() = 2
            @ nLine,nCol clear to nLine,MaxCol()
        else
            if pcount() = 3
                @ nLine,nCol clear to nToLine,MaxCol()
            else
                if pcount() = 4
                    @ nLine,nCol clear to nToLine,nToCol
                endif
            endif
        endif
    endif
endif

RETURN(NIL)

