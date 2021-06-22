/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_TrailSpace( cInStr ) --> nInteger

PARAMETERS:

cInStr : Character to count trailing spaces in

SHORT:

Count number of trailing spaces in a string.

DESCRIPTION:

k_TrailSpace() counts the number of trailing spaces in a character string.

NOTE:



EXAMPLE:

**********
t = k_LeadSpace("HOWDY!      ")

Result t = 6

******************************************************************************/


FUNCTION k_TrailSpace(cInStr)
LOCAL    i, n := 0

for i = len(cInStr) to 1 step -1
    if substr(cInStr,i,1) = ' '
        n++
    else
        exit
    endif
next

RETURN(n)

