/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_IToB( nInteger, nMax ) --> nInteger

PARAMETERS:

nInteger : Integer to convert to binary INTEGER
nMax     : Maximum Number of Binary Digits to use (See Description)

SHORT:

Convert a base 10 integer to binary (base 2).

DESCRIPTION:

k_IToB() accepts an integer and returns an integer representing the 
binary equivalent.  Leading zeros are not provided.  If you need them, pad 
the result to the desired length. 

The largest possible integer that can be so converted is: 65,536.

NOTE:

See k_IToBS() (Integer to Binary String) for conversions resulting in 
greater than 16 binary digits (65,536d).  k_IToBS() can convert integer 
values resulting in up to 52 binary digits.

EXAMPLE:

t = k_IToB(13) 
Result: t = 1101

******************************************************************************/

FUNCTION k_IToB( nNum )
STATIC   nRemainder := ''
STATIC   nCallLevel := 0
LOCAL    cRetVal    := ''

nCallLevel++

nRemainder = ( str(int(nNum % 2),1) + nRemainder )

if int(nNum) >= 2
    k_IToB(int(nNum/2))
endif

nCallLevel--

if nCallLevel = 0
    // reset nRemainder for next call
    cRetVal = nRemainder ; nRemainder = ''
endif

RETURN(val(cRetVal))

