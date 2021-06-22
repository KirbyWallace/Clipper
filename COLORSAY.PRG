/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ColorSay(nRow, nCol, cString) --> NIL

PARAMETERS:

nRow    : Row to print string    (DEFAULT: row())
nCol    : Colomn to print string (DEFAULT: col())
cString : The string to print

SHORT:

Write text on screen matching colors already on screen at that position(s).

DESCRIPTION:

k_ColorSay() prints cString on the screen, beginning at nRow, nCol and 
extending for the length of cString.

Each byte of the string is written in the current color of the row/col of the 
screen where it falls.

Thus, if the screen colors change as the string is written, cString changes 
colors with it!

It is useful for user interface design where you cannot know what color might 
be at a given set of coordinates, but you want to write something there and 
color match it regardless.

k_ColorSay() always returns NIL.

NOTE:

This function is the opposite of k_ReColor(), which changes the color of 
a screen area leaving the text there.  In this respect it is similar 
to k_Hilight().

EXAMPLE:

k_ColorSay(5,10,"BATTLESTAR GALACTICA")

Result: "BATTLESTAR GALACTICA" is written on the screen at 5,10, and each 
byte is set to the color that was already on the screen where the byte 
was written.

******************************************************************************/
#include "klipper.ch"

FUNCTION k_ColorSay(nRow,nCol,cString)

LOCAL    acColors     := { 'n','b','g','bg','r','rb','gr','w' }
LOCAL    cOldColor    := setcolor()
LOCAL    cColorString := ""

LOCAL    lBlink := FALSE
LOCAL    lHigh  := FALSE

LOCAL    nColor := 0
LOCAL    nBack  := 0

LOCAL    i := 1


for i = 1 to len(cString)

    //lHigh = FALSE
    //lBlink = FALSE

    nColor = asc(substr(savescreen(nRow,nCol+(i+1),nRow,nCol+(i+1)),2,1))

    cColorString = k_Num2Color(nColor)

    //nBack = int(nColor/16)
    //
    //nColor -= (int(nColor/16)*16)
    //
    //// check blink bit
    //if nColor >= 128
    //    nColor -= 128
    //endif
    //
    //// check high (bright) bit  Also implies BLINK BIT SET
    //if nBack > 7
    //    lBLINK = TRUE
    //    nBack -= 8
    //endif
    //
    //// check high (bright) bit
    //if nColor > 7
    //    lHigh = TRUE
    //    nColor -= 8
    //endif
    //
    //
    //// nColor now equals FORE color
    //
    //cColorString = acColors[nColor+1]+ ;
    //               iif(lHigh,'+','')+ ;
    //               iif(lBlink,'*','')+ ;
    //               '/'+acColors[nBack+1]

    setcolor(cColorString)

    @ nRow, nCol+(i+1) say substr(cString,i,1)

next

setcolor(cOldCOlor)

RETURN(NIL)


