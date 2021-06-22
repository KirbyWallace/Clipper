/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_IsAverage( anArray, nRange ) --> nElement

PARAMETERS:

anArray : Array to average and return element from
nRange  : 0  = return nearest without EXceeding average
          1  = Return nearest (DEFAULT)
          2  = Return nearest without PREceeding average

SHORT:

Determine the array element that contains the average value of the array.

DESCRIPTION:

k_IsAverage() returns the element number of an array that is or is closest to 
the average of the values in the array according to the option specified in 
nRange.

If nRange = 0, the element that contains the HIGHEST value BELOW the array 
average is returned.  That is, the closest value for n < AVERAGE (ie, "who 
of the below average group is closest to average?")

If nRange = 1, the element that is closest to the array average is returned, 
regardless of whether it is higher, lower or equal to the array average. (ie, 
"who of the entire group is closest to the group's average?")

If nRange = 2, the element that contains the LOWEST value ABOVE the array 
average is returned.  That is, the closest value for n > AVERAGE (ie, "who 
of the above average group are closest to average?).

NOTE:

The lowside and highside ranges return the element number that contains the 
closest to the average without equaling it. 

Thus:

#define LOW     0
#define CLOSEST 1
#define HIGH    2

ar := { 1,2,3,4,5,6,7,8,9 }

The average is 5

The LOW range closest is 4
The HIGH range closest is 6

The CLOSEST range closest is 5 itself, because CLOSEST includes EQUALITY 
whereas LOW and HIGH EXCLUDE equality.

EXAMPLE:

#define LOW     0
#define CLOSEST 1
#define HIGH    2

LOCAL anNums1 := { 12.1, 2.2, 7.3, 2.6, 5.9, 6.06, 0.5 } // 5.24

i = k_IsAverage(anNums1) // defaults to CLOSEST

Result: The average of the values in anArray is 5.24, so the closest value is 
5.9.  Therefore, i == 5 because anArray[5] == 5.9.

i = k_IsAverage(anNums1,LOW)

Result:  The average of the values in anArray is 5.24, so the closest value 
without exceeding the average is 2.6.  Therefore, i == 4 because anArray[4] 
== 2.6


i = k_IsAverage(anNums1,HIGH)

Result:  The average of the values in anArray is 5.24, so the closest 
value without PRECEEDING the average is 5.9.  Therefore, i == 4 because 
anArray[5] == 5.9

******************************************************************************/

#define LOW     0
#define CLOSEST 1
#define HIGH    2

FUNCTION k_IsAverage( anArray, nRange )
LOCAL    nRetVal := 0
LOCAL    nAverage
LOCAL    nClosestElement
LOCAL    i
LOCAL    nTemp

nRange = iif(nRange = NIL,CLOSEST,nRange)

nAverage = k_AAverage( anArray )

do case

    case nRange = LOW

        nClosestElement = 0.00

        for i = 1 to len(anArray)

            if anArray[i] < nAverage .and. anArray[i] > nClosestElement
                nClosestElement = anArray[i]
            endif

        next

    case nRange = CLOSEST

        // set nClosestElement to highest value in array

        nTemp = 0

        for i = 1 to len(anArray)
            nTemp = max(nTemp,anArray[i])
        next

        for i = 1 to len(anArray)


            if max(nAverage,anArray[i]) - min(nAverage,anArray[i]) < nTemp
                nTemp = max(nAverage,anArray[i]) - min(nAverage,anArray[i])
                nClosestElement = i
            endif

        next

    case nRange = HIGH

        // set nClosestElement to highest value in array

        nClosestElement = 0

        for i = 1 to len(anArray)
            nClosestElement = max(nClosestElement,anArray[i])
        next

        for i = 1 to len(anArray)

            if anArray[i] > nAverage .and. anArray[i] < nClosestElement
                nClosestElement = anArray[i]
            endif

        next

endcase

RETURN(nClosestElement)



