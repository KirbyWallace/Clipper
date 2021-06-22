/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Nearest( nNum1, nNum2 nTarget, nRange )

PARAMETERS:

nNum1   : first number to test against nTarget
nNum2   : second number to test against nTarget
nTarget : nTarget (the number that nNum1 and nNum2 are tested against)
nRange  : 0  = return nearest without EXceeding nTarget
          1  = Return nearest (DEFAULT)
          2  = Return nearest without PREceeding nTarget

SHORT:

Determine which of two values is closest to target value (with rules).

DESCRIPTION:

k_Nearest() is a fairly complex function that compares nNum1 and nNum2 against 
nTarget and returns:

1 - nNum1 is nearer to nTarget than nNum2 WITHIN the given rules
2 - nNum2 is nearer to nTarget than nNum1 WITHIN the given rules
0 - Neither number is closer to nTarget WITHIN the given rules because:

    EITHER : nNum1 and nNum2 BOTH exceed nTarget and nRange = LOW
        OR : nNum1 and nNum2 BOTH preceede nTarget and nRange = HIGH
        OR : nNum1 = nNum2
        OR : (lower_num+n) = (higher_num-n) and RANGE = CLOSEST

Examples of conditions returning a value of 0:

    ************************ EX 1


    nNum1   = 6
    nTarget = 7
    nNum2   = 8

    (6+1) = 7 = (8-1)

    ************************ EX 2

    nNum1   = 4
    nTarget = 8
    nNum2   = 12

    (4+4) = 8 = (12-4)

    ************************ EX 3

    nNum1   = 12
    nTarget = 8
    nNum2   = 4

    (12-4) = 8 = (4+4)

    In other words, Range = CLOSEST, but both numbers are equidistant from 
nTarget on opposite sides.  More examples follow.

NOTE:



EXAMPLE:

#define CLOSEST 0
#define LOW     1
#define HIGH    2


? 'CLOSEST EXAMPLES'
? '---------------------------------------------------------------'

? k_Nearest(3,4,5)         // 2 - Range Not specified so default is
? k_Nearest(4,3,5)         // 1 - CLOSEST

? k_Nearest(3,4,5,CLOSEST) // 2 - These will be the same as above
? k_Nearest(4,3,5,CLOSEST) // 1 - because of default to CLOSEST

? k_Nearest(4,4,5,CLOSEST) // 0 - nNum1 = nNum2 : neither are nearer
? k_Nearest(5,5,5,CLOSEST) // 0 - ditto

? 'HIGH EXAMPLES'
? '---------------------------------------------------------------'

? k_Nearest(9,12,10,HIGH)   // 2 - because 9 is lower than nTarget
? k_Nearest(9,1000,10,HIGH) // 2 - ditto above
? k_Nearest(8,9,10,HIGH)    // 0 - Both are below nTarget

? 'LOW EXAMPLES'
? '---------------------------------------------------------------'

? k_Nearest(7,5,10,LOW)    // 1
? k_Nearest(7,11,10,LOW)   // 1 - because 11 exceeds nTarget
? k_Nearest(7,7,10,LOW)    // 0 - Both are equal
? k_Nearest(6,7,10,LOW)    // 2
? k_Nearest(17,18,10,LOW)  // 0 - Both exceed nTarget
? k_Nearest(17,17,10,LOW)  // 0 - Both equal/exceed nTarget

? 'EQUALITY EXAMPLES - not equal to each other but from nTarget'
? '---------------------------------------------------------------'

? k_Nearest(5,7,6,CLOSEST)   // All these return 0
? k_Nearest(4,6,5,CLOSEST)   //
? k_Nearest(13,7,10,CLOSEST) //
? k_Nearest(7,13,10,CLOSEST) //

? 'MORE EXAMPLES'
? '---------------------------------------------------------------'

? k_Nearest(4,4,5)      // 0 neither is nearer than the other
? k_Nearest(4.1,3,5)    // 1
? k_Nearest(3,6,5)      // 2
? k_Nearest(3,6,5,LOW)  // 1 (nNum2 exceeds nTarget)
? k_Nearest(6,3,5,LOW)  // 2 (nNum1 exceeds nTarget)


Note that k_Nearest() will also accept dates in place of nNum1, nNum2 
and nTarget:

t = k_Nearest(ctod('01/21/93), ctod('01/26/93'), ctod('01/25/93'), LOW)

Result: t = 1 // because 01/26/93 exceeds target date and Range = LOW

******************************************************************************/


#define LOW     0
#define CLOSEST 1
#define HIGH    2

FUNCTION k_Nearest(nNum1, nNum2, nTarget, nRange)
LOCAL    nRetVal := 0

nRange = iif(nRange = NIL,CLOSEST,nRange)

if nNum1 == nNum2
    // no matter what the range, if both are equal, neither is closer than the other
    nRetVal = 0
else

    do case

    case nRange = LOW

        do case

        case (nNum1 > nTarget .and. nNum2 > nTarget)
            // both disqualified
            nRetVal = 0

        case (nNum2 > nTarget .and. nNum1 <= nTarget)
            // nNum2 is disqualified
            nRetVal = 1

        case (nNum1 > nTarget .and. nNum2 <= nTarget)
            // nNum1 is disqualified
            nRetVal = 2

        case (nNum1 < nTarget .and. nNum2 < nTarget)
            // both are qualified and NOT equal

            nRetVal = iif(nNum1 > nNum2, 1, 2)

        endcase

    case nRange = CLOSEST

        do case

        case (nNum1 = nTarget .and. nNum2 != nTarget)
            // nNum1 = ntarget
            nRetVal = 1

        case (nNum2 = nTarget .and. nNum1 != nTarget)
            // nNum2 = nTarget
            nRetVal = 2

        case (nNum1 < nTarget .and. nNum2 < nTarget)
            // both qualified and not equal
            nRetVal = iif(nNum1 > nNum2,1,2)

        case (nNum1 > nTarget .and. nNum2 > nTarget)
            // both are qualified and NOT equal
            nRetVal = iif(nNum1 < nNum2, 1, 2)

        case (nNum1 < nTarget .and. nNum2 > nTarget)
            // both are qualified and NOT equal
            // nNum1 low-side, nNum2 high-side

            if ((nTarget - nNum1) = ( nNum2 - nTarget ))
                nRetVal = 0
            else
                nRetVal = iif(((nTarget - nNum1) < ( nNum2 - nTarget )), 1, 2)
            endif

        case (nNum1 > nTarget .and. nNum2 < nTarget)
            // both are qualified and NOT equal
            // nNum1 high-side, nNum2 low-side

            if ((nTarget - nNum2) = ( nNum1 - nTarget ))
                nRetVal = 0
            else
                nRetVal = iif(((nTarget - nNum2) < ( nNum1 - nTarget )), 2, 1)
            endif

        endcase


    case nRange = HIGH

        do case

        case (nNum1 < nTarget .and. nNum2 < nTarget)
            // both disqualified
            nRetVal = 0

        case (nNum1 > nTarget .and. nNum2 <= nTarget)
            // nNum2 is disqualified
            nRetVal = 1

        case (nNum2 > nTarget .and. nNum1 <= nTarget)
            // nNum1 is disqualified
            nRetVal = 2

        case (nNum1 > nTarget .and. nNum2 > nTarget)
            // both are qualified and NOT equal

            nRetVal = iif(nNum1 < nNum2, 1, 2)

        endcase

    endcase

endif


RETURN(nRetVal)

