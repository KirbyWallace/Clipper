/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Int2LB(nInteger, nPlaces)

PARAMETERS:

nInteger: integer value to convert to binary string
nPlaces : Number of binary places to return (1-8)

SHORT:

Convert integer to long binary string

DESCRIPTION:

k_Int2LB() is exactly like _Int2B() with the exception that it can handle a
return binary string up to 64 places in length.

NOTE:

THIS IS A SPECIAL VERSION OF THIS C FUNCTION WRITTEN SPECIFICALLY TO WORK WITH
MSC 5.1 *NOT* MSC 6.0!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

EXAMPLE:

? k_Int2LB(13,4)   // "1101"
? k_Int2LB(13,8)   // "0001101"
? k_Int2LB(13,32)  // "00000000000000000000000000001101"

******************************************************************************/

#include <extend.h>

CLIPPER k_int2lb(void) {

    char retval[65];
    int place = 63;

    unsigned long num = _parnl(1);  // num to be converted

    int digits = _parni(2);         // number of digits to return (1-64)
    int i = 0;

    unsigned long remainder = num;

    for (i=0; i<=64; i++)
        retval[i] = '0';

    retval[65] = '\0';

    if (_parinfo(2) != 2)
        digits = 64;

    if ( (digits < 1) || (digits > 64) )
        digits = 64;


    while (num >= 2 ) {

        remainder = num % 2;
        retval[place--] = (remainder == 1 ? '1':'0');
        num /= 2;

    } 

    retval[place--] = (num == 1 ? '1':'0');

    _retc( retval+(64-digits) );

}

