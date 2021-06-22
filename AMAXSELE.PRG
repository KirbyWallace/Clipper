/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_AMaxStrElement( acArray ) --> nLongestElement

PARAMETERS:

acArray : array of character strings

SHORT:

Get element number of longest character string in array.

DESCRIPTION:

k_AMaxStrElement() returns the number of the element associated with 
longest character string in an array of strings.

If the array is empty, the return value is 0. If any element of the array 
is not of type char, the return value is 0.

Note: The return value does not necessarily identify any particular 
array element because two element strings may be the same length.

NOTE:

See also: 

k_AMaxStrLen() which returns the length of the longest string of an array.

EXAMPLE:

LOCAL aArray := { 'a','aaa','aaaaaaaaa','aa'}
t = k_AMaxStrElement( aArray )

Result: t = 3

LOCAL aArray := {}
t = k_AMaxStrElement( aArray )


Result: t = 0

******************************************************************************/

FUNCTION k_AMaxStrElement( acArray )
LOCAL    nRetVal := 0
LOCAL    nTemp := 0
LOCAL    i


for i = 1 to len(acArray )

    if valtype(acArray[i]) != 'C'
        nRetVal = 0
        EXIT
    endif

    if len(acArray[i]) > nTemp

        nTemp = len(acArray[i])
        nRetVal = i

    endif

next


RETURN(nRetVal)

