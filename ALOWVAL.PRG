/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ALowVal( axArray ) --> xHighVal

PARAMETERS:

axArray : array of CHAR, DATE, or NUM elements

SHORT:

Get the LOWEST value from an array of char, num, or date.

DESCRIPTION:

k_ALowVal() returns the lowest value from an array of Character Strings, 
Dates or Numerics.

ALL elements must be of the same type! If the array contains mixed elements, 
a run-time error will occur.

If the array in not CHAR, DATE, or NUM, the return value is NIL.

NOTE:

See also:

k_AHighVal() which returns the highest value.

k_ALowElement() which returns the element number associated with the 
lowest value.

k_AHighElement() which returns the element number associated with the 
highest value.

EXAMPLE:

LOCAL aArray := { 2,5,3,9,12,7 }
t = k_ALowVal( aArray )

Result: t = 2


LOCAL aArray := { 'Wallace', 'Jones', 'Taylor', 'Abdul'  }
t = k_ALowVal( aArray )

Result: t = 'Abdul'

******************************************************************************/
FUNCTION k_ALowVal( axArray )
LOCAL    xRetVal := NIL
LOCAL    i


if ( valtype(axArray[1]) $ 'CDN' )

    xRetVal = axArray[1]

    for i = 2 to len(axArray)

        if !( valtype(axArray[i]) $ 'CDN' )

            xRetVal = NIL
            exit

        endif

        if axArray[i] < xRetVal

            xRetVal = axArray[i]

        endif

    next

endif


RETURN(xRetVal)


