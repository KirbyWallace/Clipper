/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_AHighVal( axArray ) --> xHighVal

PARAMETERS:

axArray : array of CHAR, DATE, or NUM elements

SHORT:

Get the highest VALUE from an array of chars, numerics or dates.

DESCRIPTION:

k_AHighVal() returns the highest value from an array of Character 
Strings, Dates or Numerics.

ALL elements must be of the same type! If the array contains mixed elements, 
a run-time error will occur.

If the array in not CHAR, DATE, or NUM, the return value is NIL




NOTE:

See also:

k_ALowVal() which returns the lowest value from an array.

k_ALowElement() which returns the element number associated with the 
lowest value.

k_AHighElement() which returns the element number associated with the 
highest value.

EXAMPLE:

LOCAL aArray := { 1,5,3,9,12,7 }
t = k_AHighVal( aArray )

Result: t = 12


LOCAL aArray := { 'Wallace', 'Jones', 'Taylor', 'Abdul'  }
t = k_AHighVal( aArray )

Result: t = 'Wallace'

******************************************************************************/

FUNCTION k_AHighVal( axArray )
LOCAL    xRetVal := NIL
LOCAL    i


if ( valtype(axArray[1]) $ 'CDN' )

    xRetVal = axArray[1]

    for i = 2 to len(axArray)

        if !( valtype(axArray[i]) $ 'CDN' )

            xRetVal = NIL
            exit

        endif

        if axArray[i] > xRetVal

            xRetVal = axArray[i]

        endif

    next

endif


RETURN(xRetVal)

