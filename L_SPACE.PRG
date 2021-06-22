/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_LeadSpace( cInStr ) --> nInteger

PARAMETERS:

cInStr : Character string to count leading spaces in

SHORT:

Count the numer of leading spaces in a character string.

DESCRIPTION:

k_LeadSpace() counts the number of leading spaces in a character string.

NOTE:



EXAMPLE:

t = k_LeadSpace("    HOWDY!")

Result t = 4

******************************************************************************/

FUNCTION k_LeadSpace(cInStr)
LOCAL    i, n := 0

for i = 1 to len(cInStr)
    if substr(cInStr,i,1) = ' '
        n++
    else
        exit
    endif
next

RETURN(n)

