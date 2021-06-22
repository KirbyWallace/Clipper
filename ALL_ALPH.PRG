/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_AllAlpha( cInStr ) --> lIsAllAlpha

PARAMETERS:

cInStr : Character string to check for all alphabetic chars




SHORT:

Check if all characters in a string are alphabetic (A...Z only).

DESCRIPTION:

_All_Alpha returns TRUE only if every character in a string is an A...Z, 
no puncuation, and no digits.

NOTE:



EXAMPLE:

? k_AllAlpha('English Class')      // .T.
? k_AllAlpha('English 101 Class')  // .F.  the "101" throws it.

******************************************************************************/

FUNCTION k_AllAlpha( cInStr )
LOCAL    lRet_Val := .t.
LOCAL    i

if empty(cInStr)
    lRet_Val = .f.
else
    for i = 1 to len(trim(cInStr))
        if !isalpha(substr(cInStr,i,1))
            lRet_Val = .f.
            EXIT
        endif
    next
endif

RETURN(lRet_Val)
