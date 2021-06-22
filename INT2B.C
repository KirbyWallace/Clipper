/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Int2B(nInteger, nPlaces) --> cBinString

PARAMETERS:

nInteger: integer value to convert to binary string
nPlaces : Number of binary places to return (1-8)

SHORT:

Convert integer to binary string

DESCRIPTION:

k_Int2B() converts integer numerics to equivalent binary string representation.

NOTE:

THIS IS A SPECIAL VERSION OF THIS C FUNCTION WRITTEN SPECIFICALLY TO WORK WITH
MSC 5.1 *NOT* MSC 6.0!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

EXAMPLE:

? k_Int2B(13,4)  // "1101"
? k_Int2B(13,8)  // "0001101"

******************************************************************************/

#include <extend.h>

CLIPPER k_int2b(void) {

    char retval[9];  // return string

    int place = 7;                // "current" place marker

    int num = _parni(1);          // integer to convert
    int digits = _parni(2);       // number of digits to return (1-8)

    int i = 0;
    int r = num;

    for (i = 0; i<=7; i++ )
        retval[i] = '0';

    retval[8] = '\0';

    if (_parinfo(2) != 2)
        digits = 8;

    if ( (digits < 1) || (digits > 8) )
        digits = 8;

    while (num >= 2 ) {

        r = num%2;
        retval[place--] = (r == 1 ? '1':'0');
        num /= 2;

    } 

    retval[place--] = (num == 1 ? '1':'0');

    _retc( retval+(8-digits) );

}

