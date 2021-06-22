/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_NthOccr( cInStr, cInChar, nNthOccr ) --> nInteger

PARAMETERS:

cInStr   = string to be searched
cInChar  = string looking for
nNthOccr = 'nth' occurance of cInChar.

SHORT:

Return the "nth" occurance of one string in another string (delimited).

DESCRIPTION:

k_NthOccr() returns the position of "nNthOccr" occurance of string "cInChar" 
in string "cInStr" or zero if cInChar string is not in cInStr at all or the 
specified occurance is more than the number of occurances.

NOTE:

See also: k_Extract()

EXAMPLE:

? k_NthOccr('AB/CD/EF/GH','/',2) // Returns 6
? k_NthOccr('AB/CD/EF/GH','/',3) // Returns 9
? k_NthOccr('AB/CD/EF/GH','/',4) // Returns 0

******************************************************************************/

FUNCTION k_NthOccr(cInStr,cInChar,nNthOccr)
LOCAL    i, nOcc

nOcc=0

for i=1 to len(cInStr)
    if substr(cInStr,i,1) = cInChar
        nOcc++
        if nOcc=nNthOccr
            RETURN(i)
        endif
    endif
next

*/ return 0 if not found at all or at specified occurance /*

RETURN(0)

