/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Num2Color( nColor ) --> cColor

PARAMETERS:

nColor : Color number (NOT Clipper Color #, per se: see description)

SHORT:

Convert Clipper INTERNAL color number to color string.

DESCRIPTION:

k_Num2Color() translates the numbers that Clipper uses internally to represent 
color ATTRIBUTES.  THIS IS NOT THE SAME THING AS CLIPPER'S COLOR NUMBERS (ie, 
0-Black, 1-Blue, etc).

nColor is usually extracted from a savescreen() coordinate, and the number 
represents a complete color attribute, not an individual color.

For instance, the number 202 represents " G+* / R " to Clipper. This function 
is used by k_ColorSay() which shows it's correct usage.

Do NOT feed this function Clipper @ SAY/GET color numbers! Psychadelic-drug 
hallucination-like mayhem may result!  But, hey, it might be interesting to 
try it anyway!

NOTE:



EXAMPLE:

k_Num2Color(substr(screensave(5,10,5,10),2,1))

Result: The current color attribute at 5,10 is returned as a color 
string: FORE/BACK.

******************************************************************************/
#include "klipper.ch"

FUNCTION k_Num2Color(nColor)
LOCAL    acColors := { 'n','b','g','bg','r','rb','gr','w' }
LOCAL    cColor   := ""
LOCAL    lHigh    := FALSE
LOCAL    lBlink   := FALSE
LOCAL    nBack

nBack = int(nColor/16)

nColor -= (int(nColor/16)*16)

// check blink
if nColor >= 128
    nColor -= 128
endif

// check high (bright) bit  Also implies BLINK BIT SET!!
if nBack > 7
    lBLINK = TRUE
    nBack -= 8
endif

// check high (bright) bit
if nColor > 7
    lHigh = TRUE
    nColor -= 8
endif


// nColor now equals FORE color

cColor = acColors[nColor+1]+ ;
         iif(lHigh,'+','')+ ;
         iif(lBlink,'*','')+ ;
         '/'+acColors[nBack+1]

RETURN(cColor)

