/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ToPower( nNum1, nNum2 ) --> nInteger

PARAMETERS:

nNum1 : Base Number
nNum2 : Exponent (power)

SHORT:

Exponent function (Don't get too excited!).

DESCRIPTION:

k_ToPower() will raise nNum1 to the nNum2 power.  It will also handle 
negative powers.

NOTE:

I wrote this function a LONG time ago BEFORE I remembered that there was a 
standard operator for doing it.  Oh well...

EXAMPLE:

number = k_ToPower(3,0)  // number = 1
number = k_ToPower(3,1)  // number = 3
number = k_ToPower(3,2)  // number = 9
number = k_ToPower(3,4)  // number = 27
number = k_ToPower(3,-1) // number = 0.33

******************************************************************************/

FUNCTION k_ToPower(nNum1, nNum2)
LOCAL    nNum3, i

do case

    case nNum2 == 0
        nNum3 = 1

    case nNum2 == 1
        nNum3 = nNum1

    case nNum2 > 0
         nNum3 = 1

         for i = 1 to nNum2
             nNum3 *= nNum1
         next

    case nNum2 < 0
        nNum3 = 0.000000 + nNum1

        for i = 0 to nNum2 STEP -1
            nNum3 /= nNum1
        next

endcase

RETURN(nNum3)

