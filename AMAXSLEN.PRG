/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_AMaxStrLen( acArray ) --> nLongestStringLength

PARAMETERS:

acArray : array of characters

SHORT:

Determine the length of the longest string from an array of strings.

DESCRIPTION:

k_AMaxStrLen() returns the length of the longest character string in an 
array of strings.

If the array is empty, the return value is 0. If any element of the array 
is not of type char, the return value is 0.

NOTE:

The return value does not necessarily uniquely identify any particular array 
element because two elements may have the same length.  This function only 
tells you how long the LONGEST element is.  In the case of a tie, it doesn't 
matter which.

See also: AMaxStrLen() which returns the element number associated with the 
longest string element.

EXAMPLE:

LOCAL aArray := { 'a', 'bbbbbbbbb', 'aaa', 'aaaaaaaaa', 'aa'}
t = k_AMaxStrLen( aArray )

Result: t = 9

Note that both the second element and the fourth element are both 9 
characters long.  The function returns 9 regardless.

******************************************************************************/

FUNCTION k_AMaxStrLen( acArray )
LOCAL    nRetVal := 0
LOCAL    i


for i = 1 to len(acArray )

    if valtype(acArray[i]) != 'C'
        nRetVal = 0
        EXIT
    endif

    if len(acArray[i]) > nRetVal

        nRetVal = len(acArray[i])

    endif

next


RETURN(nRetVal)

