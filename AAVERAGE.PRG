/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_AAverage( anArray ) --> nAverage

PARAMETERS:

anArray : Array of numeric values to average.

SHORT:

Get average value of a numeric array.

DESCRIPTION:

k_AAverage() returns the average of the numeric elements given in anArray.  
NIL elements are not factored into the average so the result reflects only 
the average of actual values (inlcuding ZERO).


NOTE:



EXAMPLE:

LOCAL anNums1 := { 1,2,3,4,5,6,7 } // 4
LOCAL anNums2 := { 12.1,2.2,7.3,2.6,5.9,6.06,0.5 } // 5.24

i = k_AAverage(anNums1)
j = k_AAverage(anNums2)

Result:

i = 4
j = 5.237142857 (5.24 with SET DECIMALS TO 2)


******************************************************************************/
FUNCTION k_AAverage( anArray )
LOCAL    nRetVal := 0.00
LOCAL    i, j, k

i := j := k := 0

for i = 1 to len(anArray)

    if valtype(anArray[i]) == 'N'

        k += anArray[i]; j++

    end

next

if j > 0
    nRetVal = k/j
endif

RETURN(nRetVal)

