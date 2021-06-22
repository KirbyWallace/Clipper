/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Neon( nRow, nCol, cMsg ) --> NIL

PARAMETERS:

nRow : Row and col of screen
nCol : "                   "
cMsg : Text to display

SHORT:

A truly brainless wonder!

DESCRIPTION:

k_Neon() takes the cMsg character string and displays it in a really 
nifty "teletype" type way. Neato! A little "blip" at each character: like 
the great special effects you see on such high-quality shows as Dr. Who!

"Intruder Alert!"  (I gotta go!)

NOTE:

If you like this, you are strange.  If you actually USE it in an application, 
I suggest you seek professional help quick!  Personally, I've done both!

EXAMPLE:

k_Neon(24,0,'Intruder Alert! - Intruder Alert!')

******************************************************************************/

#include "setcurs.ch"
#include "klipper.ch"

FUNCTION k_Neon(nRow, nCol, cMsg)
LOCAL    i, Old_Curs := set(_SET_CURSOR,SC_BLOCK)

nRow=iif(nRow=NIL,row(),nRow)
nCol=iif(nCol=NIL,col(),nCol)

for i = 1 to len(cMsg)
    tone(8000,.1)
    @ nRow,nCol+i-1 say substr(cMsg,i,1)
next

set(_SET_CURSOR,Old_Curs)

RETURN(NIL)

