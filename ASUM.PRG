/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ASum( anArray, nDim ) --> nSum

PARAMETERS:

anArray : Array of Numerics
nDim    : The array element dimension (if multi-dimensional)

SHORT:

Sum the values of an array of numerics.

DESCRIPTION:

k_ASum() returns the sum of all numbers in an array of numerics.

If any element of the array is not numeric, it is ignored. Thus, an array of 
one character string and five numbers can be summed.  NIL elements are also 
ignored.

If there are no numeric elements in the array, the return value is ZERO.

If the array is multidimensional, you MUST specify nDIM, specifying which 
dimension to sum.  If you attempt to k_ASum() a multi-dimensional array but do 
not specify the dimension, 1 is assumed.

NOTE:



EXAMPLE:

LOCAL aMonthlyData := { 'Wallace',1,2,3,4,5,6,7,8,9,10,11,12 }

t = k_ASum( ar )

Result: t = 78  Character aMonthlyData[1] is ignored.


anData1 = { 1,2,3,4,"FIVE",6}

anData2 = {  {'One',   1   }, ; 
             {'two',   2   }, ;
             {'three', 3   }, ; 
             {'four',  4   }, ;
             {'five',  NIL }, ;
             {'six',   6   }  }

t = k_ASum(anData1)    // 16 single dimension
t = k_ASum(anData2,2)  // 16 multi-dimension, checking second dim.

******************************************************************************/

FUNCTION k_ASum( anArray, nDim )
LOCAL    nRetVal := 0
LOCAL    i

for i = 1 to len(anArray)

    if nDim != NIL

        if valtype(anArray[i,nDim]) == 'N'
            nRetVal += anArray[i,nDim]
        endif

    else

        if valtype(anArray[i]) == 'N'
            nRetVal += anArray[i]
        endif

    endif

next

RETURN(nRetVal)

