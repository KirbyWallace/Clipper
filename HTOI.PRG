/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_HToI( cVar ) --> nIntege

PARAMETERS:

cVar : Hexadecimal Value (character string)

SHORT:

Convert hexadecimal to decimal integer.

DESCRIPTION:

k_HToI() converts a Hexadecimal string to its Base 10 numeric equivalent.

NOTE:



EXAMPLE:

? k_HToI('F')  // returns 15
? k_HToI('FF') // returns 255
? k_HToI('5')  // returns 5 (because 5 = 5 in base 10)

******************************************************************************/
FUNCTION k_HToI(cVar)
LOCAL    nInt := 0
LOCAL    i
LOCAL    nVal


for i = 1 to len(cVar)

     if upper(substr(cVar,i,1)) $ 'ABCDEF'
         nVal = 9 + k_Ap(substr(cVar,i,1))
     else
         nVal = val(substr(cVar,i,1))
     endif

     nInt += nVal * (16^(len(cVar)-i))

next

RETURN(nInt)

