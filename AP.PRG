/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Ap( cAp_Char ) --> nOrdinalPosition

PARAMETERS:

cAp_Char : alphabetic character

SHORT:

Determine alphabetic ordinal position of an alphabetic character.

DESCRIPTION:

k_Ap() returns the numeric alphabetic position of the letter passed. I had 
a good use for it once, but forgot what it was.

NOTE:



EXAMPLE:

? k_Ap('A')   // 1
? k_Ap('K')   // 11
? k_Ap('Z')   // 26

******************************************************************************/

FUNCTION k_Ap(cAp_Char)
RETURN(iif(cAp_Char = NIL,0,at(lower(cAp_Char),'abcdefghijklmnopqrstuvwxyz')))

