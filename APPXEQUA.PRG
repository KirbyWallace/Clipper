/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_AppxEqual(nNum1, nNum2, nDec) --> lIsAppxEqual

PARAMETERS:

nNum1: number to compare to nNum2
nNum2: number to compare to nNum1
nDecs: number of decimal places to compare.

SHORT:

Determine floating point equality to a given decimal place.

DESCRIPTION:

k_AppxEqual() determines if two floating point values are equal WITHIN the 
given number of decimal places.  This is a very common operation when dealing 
with comparisons of floating point numbers.

The function is useful when trying to find an acceptable equality between two 
floating point numbers when they can never be exactly equal (thus foiling 
any use of the "=" operator).

NOTE:



EXAMPLE:

nNum1 = 3.141592654
nNum2 = 3.141592655

? k_AppxEqual(nNum1, nNum2, 9)

FALSE  the numbers are not equal to nine decimal places.


? k_AppxEqual(nNum1, nNum2, 8)  

However, they are equal to eight decimals places, so the return value is 
TRUE.

******************************************************************************/

FUNCTION k_AppxEqual(nNum1, nNum2, nDecs)

LOCAL    cNum1 := str(nNum1)
LOCAL    cNum2 := str(nNum2)

RETURN( (int(nNum1) == int(nNum2)) .and. substr(cNum1,at('.',cNum1)+1,nDecs) == substr(cNum2,at('.',cNum2)+1,nDecs) )

