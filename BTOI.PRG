/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_BtoI( xIn_Var ) --> nInteger

PARAMETERS:

xIn_Var : Binary number in either numeric or string format to convert

SHORT:

Convert Binary to Decimal Integer.

DESCRIPTION:

k_BtoI() accepts either a numeric or a string representation of a binary 
number and returns an integer representing the decimal equivalent.  If 
the significant digits of the binary number exceed 16, you should pass 
the binary number as a string to avoid loss of digits during the 
parameter pass.  k_BtoI() detects which mode the number was passed in 
and adjusts accordingly.  In either case, the decimal return value is 
always numeric.

The maximum NUMERIC value that can be converted is 1111111111111111 
(2^15) because anything larger than that is lost when the parameter is 
passed as a numeric.  Pass the number as a string for binary values 
greater than 16 digits.

Binary points are supported.

NOTE:

This function is equivalent to using _BX2BY() or _BasX2Dec() to accomplish 
the same thing.  The syntax of this one is geared specifically to the Bin to 
Dec conversion.

EXAMPLE:

k_BtoI(1101)      // returns 13
k_BtoI('1101')    // returns 13

******************************************************************************/

FUNCTION k_BtoI(xIn_Var)
LOCAL    i
LOCAL    j
LOCAL    k

LOCAL    cInt_Part
LOCAL    cFrac_Part

LOCAL    jInt
LOCAL    jFrac

if valtype(xIn_Var) == 'N'
    xIn_Var = alltrim(str(xIn_Var))
else
    xIn_Var = alltrim(xIn_Var)
endif

**********************************************
* see if we have a binary point to deal with *
**********************************************

if at('.',xIn_Var) > 0

    cInt_Part = substr(xIn_Var,1,at('.',xIn_Var)-1)
    cFrac_Part = substr(xIn_Var,at('.',xIn_Var)+1)

    jint = 0  // integer part accumulator
    k    = 0  // substr counter

    for i = len(cInt_Part)-1 to 0 step -1

        k++

        if (substr(cInt_Part,k,1) == '1')

            // jint += k_ToPower(2,i)
            jint += 2^i

        endif

    next

    jfrac = 0  // fractional part accumulator
    k     = 0  // substr counter

    for i = 1 to len(cFrac_Part)

        k++

        if (substr(cFrac_Part,k,1) == '1')

            //jfrac += k_ToPower(2,i-(i*2))
            jfrac += 2^(i-(i*2))

        endif

    next

    j = jint+jfrac

else

    ********************************
    * accumulator / substr counter *
    ********************************

    j = 0  ; k = 0

    for i = len(xIn_Var)-1 to 0 step -1

        k++

        if (substr(xIn_Var,k,1) == '1')

            // j += k_ToPower(2,i)
            j += 2^i

        endif

    next

endif


RETURN(j)

