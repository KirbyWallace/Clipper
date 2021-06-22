/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Chars( nLowBound, nHighBound ) --> cString

PARAMETERS:

nLowBound  : Lowest character of string to create
nHighBound : Highest character of string to create

SHORT:

Create a string of characters between a low and high range.

DESCRIPTION:

_CharString() accepts two numeric parameters, representing ASCII code 
ranges, and builds and returns a string of characters bounded by nLowBound 
and nHighBound.

This is another of those functions that I needed at the time but forgot why 
now.

NOTE:



EXAMPLE:

t = _charstr(65,75)

Result: t = 'ABCDEFGHIJK'

******************************************************************************/

FUNCTION k_Chars(nLowBound,nHighBound)
LOCAL    cResult := ''
LOCAL    i

for i = nLowBound to nHighBound
    cResult += chr(i)
next

RETURN(cResult)

