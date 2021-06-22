/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ReColor( nFRow, nFCol, nTRow, nTCol, cColor) --> NIL

PARAMETERS:

nFRow   : Screen area coordinates
nFCol   : ""
nTRow   : ""
nTCol   : ""
cColor  : Color to rewrite region in

SHORT:

Rewrite screen region in different color, leaving text intact.

DESCRIPTION:

k_ReColor() redraws a screen region in a different color leaving the text 
there intact. 

Since the only "default" color would be the current color, there is not 
much sense in not specifying it.  However, if cString is not specified, 
the default is in fact the current color setting.

If any of the screen area coordinates are not specified, the function 
does nothing and immediately returns NIL.

NOTE:

This function is the opposite of k_ColorSay() which writes text on the 
screen in the colors already there.

EXAMPLE:

k_ReColor(5,10,7,40,"W*+/R")

Result: Whatever is currently in the area of the screen at the given 
coordinates is rewritten in blinking high white on a red background.

******************************************************************************/
#include "klipper.ch"

FUNCTION k_ReColor(nFRow, nFCol, nTRow, nTCol, cColor)

LOCAL    cScreen := savescreen(nFRow, nFCol, nTRow, nTCol)
LOCAL    i

cColor = iif(cColor = NIL,setcolor(),cColor)

for i = 1 to len(cScreen) STEP 2

    cScreen = stuff(cScreen,i+1,1,chr(k_Color2Num(cColor)))

next

restscreen(nFRow, nFCol, nTRow, nTCol,cScreen)


RETURN(NIL)


