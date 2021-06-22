/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_InRange( ndInVar, ndInLow, ndInHigh ) --> lInRange

PARAMETERS:

ndIn_Var     Value to check
ndIn_Low     Low Limit
ndIn_High    High Limit

SHORT:

Determine if a numeric or date value is within a specified range.

DESCRIPTION:

_In_Range returns TRUE if ndIn_Var is greater than OR EQUAL TO ndIn_Low AND 
less than OR EQUAL TO ndIn_High. 

_In_Range works on data types of date and numeric only.

The order of the hi/low ranges is not set in concrete.  They may be low to 
high or vice versa. That is, the High Range may contain the low value and the 
Low range may contain the High Value.  They values are manipulated as 
necessary to determine of the value is within this range regardless.

This is handy if you want to test a range for KEYSTROKE values, for instance, 
F2 - F10, where the order runs backward and you want to keep it simple in 
appearance. F2 - F10 would be -1 through -9 which makes them appear to run 
high to low rather than low to high when in actuality, that is the way 
negative numbers run.

NOTE:



EXAMPLE:

k_InRange(5,2,10)  // .T.
k_InRange(5,10,2)  // .T.
k_InRange(-5,-4,5) // .F.


* Notice in the following the reversing of the hi/low ranges

t = 5
logical1 = k_InRange(t,1,10)
Result: logical1 = TRUE

logical2 = k_InRange(t,10,1)
Result: logical2 = TRUE.


t  = ctod('11/15/91')
lo = ctod('11/01/91')
hi = ctod('11/30/91')

logical3 = k_InRange(t,lo,hi)
Result: logical3 = TRUE

logical4 = k_InRange(t,hi,low)
Result: logical4 = TRUE

******************************************************************************/

FUNCTION k_InRange( ndInVar, ndInLow, ndInHigh )
LOCAL    Ret_Val
LOCAL    Old_Low

if pcount() < 3
    /* error - _wrong # params */
    Ret_Val = .f.
else
    if !valtype(ndInVar) $ 'ND' .or. !valtype(ndInLow) $ 'ND' .or. !valtype(ndInHigh) $ 'ND'
        /* error - params of wrong data type */
        Ret_Val = .f.
    endif
endif

/* have enough params of right type */

if ndInLow > ndInHigh

    /* got 'em backwards  */

    Old_Low = ndInLow
    ndInLow  = ndInHigh
    ndInHigh = Old_Low

endif

if ndInVar >= ndInLow .and. ndInVar <= ndInHigh
    Ret_Val = .t.
else
    Ret_Val = .f.
endif

RETURN(Ret_Val)

