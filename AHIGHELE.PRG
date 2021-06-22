/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_AHighElement( axArray ) --> nHighElement

PARAMETERS:

axArray : array of CHAR, DATE, or NUM elements


SHORT:

Find element with highest numeric, char or date value.

DESCRIPTION:

k_AHighElement() returns the element number associated with the highest 
value from an array of Character Strings, Dates or Numerics.

ALL elements must be of the same type!

If the array contains mixed elements, a run-time error will occur. If the 
array in not CHAR, DATE, or NUM, the return value is NIL.

NOTE:

See also: 

k_ALowVal() which returns the lowest value.

k_AHighVal() which returns the highest value.

k_ALowElement() which returns the element number associated with the 
lowest value.

EXAMPLE:

LOCAL aArray := { 1,5,3,9,12,7 }
t = k_AHighElement( aArray )

Result: t = 5

LOCAL aArray := { 'Wallace', 'Jones', 'Taylor', 'Abdul'  }
t = k_AHighElement( aArray )

Result: t = 1

******************************************************************************/

FUNCTION k_AHighElement( axArray )
LOCAL    xRetVal := NIL
LOCAL    xTemp
LOCAL    i


if ( valtype(axArray[1]) $ 'CDN' )


    xTemp = axArray[1]
    xRetVal = 1

    for i = 1 to len(axArray)

        if !( valtype(axArray[i]) $ 'CDN' )

            xRetVal = NIL
            exit

        endif

        if axArray[i] > xTemp

            xTemp = axArray[i]
            xRetVal = i

        endif

    next

endif

RETURN(xRetVal)


