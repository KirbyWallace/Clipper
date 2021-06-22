/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Color2Num( cColor ) --> nColor

PARAMETERS:

cColor: a complete fore and back color setting attribute string

SHORT:

Convert a clipper color string to a Clipper internal color number.

DESCRIPTION:

k_Color2Num() converts a color from Clipper's internal method of 
representation to a literal color setting string, with foreground and 
background, as well as high and blink characters.

It does NOT convert colors to the Clipper COLOR NUMBER (ie, n - 0, b - 
1, etc).  It is typically used to read a screen region with savescreen() 
and determine the color of the screen at any given point.


NOTE:

See k_ReColor() for an example of how this function is properly employed.

EXAMPLE:

t = savescreen(5,10,5,10)
t = substr(t,1,1)+chr(k_Color2Num('w+/r'))

restscreen(5,10,5,10,t)

Result: Whatever is at screen position 5,10 is rewritten in "w+/r".  This 
is precisely what k_ReColor() does.

******************************************************************************/
#include "klipper.ch"

FUNCTION k_Color2Num(cColor)

LOCAL    lOldExact := set(_SET_EXACT,TRUE)
LOCAL    acColors := { 'n','b','g','bg','r','rb','gr','w' }
LOCAL    lBlink   := iif('*' $ cColor,TRUE,FALSE)
LOCAL    lHigh    := iif('+' $ cColor,TRUE,FALSE)
LOCAL    nColor   := 0
LOCAL    cFore
LOCAL    cBack


* Every color attribute MUST have both fore and back colors,
* thus the '/' must be present.

if '/' $ cColor

    cColor = lower(k_Convert(cColor,'/'))

    cFore = alltrim(k_Extract(cColor, '/', 1))
    cBack = alltrim(k_Extract(cColor, '/', 2))

    nColor = (ascan(acColors,cFore)-1) +      iif(lHigh ,8  ,0) + ;
             ((ascan(acColors,cBack)-1)*16) + iif(lBlink,128,0)

endif

set(_SET_EXACT,lOldExact)

RETURN(nColor)

