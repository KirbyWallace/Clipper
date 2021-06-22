/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_InArray( axArray, xData ) --> lIsInArray

PARAMETERS:

axArray : Array of CHAR, DATE, or NUM
cData   : Data to locate

SHORT:

Determine if a value is in any element of specified array.

DESCRIPTION:

k_InArray() searches the specified array for the data passed in xData.  
If found, the function returns TRUE, else FALSE.  

The array may be of mixed types, any array element incompatible with the 
data being looked for is ignored. 

In the case of character data, the return value is true if xData 
appears ANYWHERE in the element.

In the case of Date or Numeric, the return value is true only if the 
array element EXACTLY EQUALS xData.

NOTE:

k_InArray() does not return the element number associated with the found 
value, only whether it is in any of the arrays elements or not.

EXAMPLE:

LOCAL myarray := { 'One','Two','Three','Four','Five' }

t = k_InArray(myarray,'Three')
Result: t = TRUE

t = k_InArray(myarray,'ee')
Result: t = TRUE

t = k_InArray(myarray,'Seven')
Result: t = FALSE


LOCAL myarray := { 'One', 1 ,  ctod('01/01/91') }

t = k_InArray(myarray,'One')
Result: t = TRUE

t = k_InArray(myarray,1)
Result: t = TRUE

t = k_InArray(myarray,1.5)
Result: t = FALSE

t = k_InArray(myarray,ctod('01/01/91') )
Result: t = TRUE

******************************************************************************/
FUNCTION k_InArray(axArray, xData)
LOCAL    lRetVal := .f.
LOCAL    i


do case

    case valtype(xData) == 'C'

        for i = 1 to len(axArray)

            if valtype(axArray[i]) == 'C'

                if xData $ axArray[i]

                    lRetVal = .t.
                    EXIT

                endif

            endif

        next

    case valtype(xData) == 'N'

        for i = 1 to len(axArray)

            if valtype(axArray[i]) == 'N'

                if xData = axArray[i]

                    lRetVal = .t.
                    EXIT

                endif

            endif

        next

    case valtype(xData) == 'D'

        for i = 1 to len(axArray)

            if valtype(axArray[i]) == 'D'

                if xData = axArray[i]

                    lRetVal = .t.
                    EXIT

                endif

            endif

        next

endcase

RETURN(lRetVal)


