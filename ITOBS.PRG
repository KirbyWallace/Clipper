/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_IToBS( nInteger, nMax ) --> cBitString

PARAMETERS:

nInteger : Integer to convert to binary STRING
nMax     : Maximum Number of Binary Digits to use (See Description)

SHORT:

Convert a base 10 integer to binary string (up to 52 binary digits).

DESCRIPTION:

k_IToBS() accepts an integer and returns a STRING representing the 
binary equivalent.  Leading zeros are not provided.  If you need them, pad 
the result to the desired length.

The largest known possible integer that can be so converted is: 
9,999,999,999,999,998.

NOTE:



EXAMPLE:

t = k_IToBS(13)
Result: t = '1101'

t = k_IToBS(128)
Result: t = '10000000'

******************************************************************************/


FUNCTION k_IToBS( nNum )
STATIC   nRemainder := ''
STATIC   nCallLevel := 0
LOCAL    cRetVal    := ''

nCallLevel++

nRemainder = ( str(int(nNum % 2),1) + nRemainder )

if int(nNum) >= 2
    k_IToBS(int(nNum/2))
endif

nCallLevel--

if nCallLevel = 0
    // reset nRemainder for next call
    cRetVal = nRemainder ; nRemainder = ''
endif

RETURN(cRetVal)


