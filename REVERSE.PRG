/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Reverse( cStr ) --> cString

PARAMETERS:

cStr : string to reverse

SHORT:

Reverse the order of characters in a string.

DESCRIPTION:

k_Reverse() simply returns the string passed in cStr in reverse order.

NOTE:

Don't ask...

EXAMPLE:

t = k_Reverse('ABCDEFG')

Result: t = 'GFEDCBA'

******************************************************************************/

FUNCTION k_Reverse(cStr)
LOCAL i, cOutStr := ''

for i = len(cStr) to 1 STEP -1
    cOutStr += substr(cStr,i,1)
next

RETURN(cOutStr)

