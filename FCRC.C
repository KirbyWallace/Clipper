/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_cFCRC(cString) --> cCRCStamp

PARAMETERS:

cString: string to be CRC'd

SHORT:

Generate CRC on a string.

DESCRIPTION:

This function is the engine behind the CRC() function.  You should use that
function and not this one directly, as it provides greater flexibility.

NOTE:

EXAMPLE:

******************************************************************************/

#include <extend.h>

void _pascal k_cFcrc( void ) {

    long int nsum1 = 0;
    long int nsum2 = 0;
    unsigned long int nsum3 = 0;

    char *string;
    int nlen;

    string = _parc(1);
    nlen = _parclen(1);


    while (nlen--) {

        nsum1 += string[nlen];

        if (nsum1 >= 255)
            nsum1 -= 255;

        nsum2 += nsum1;

    }

    nsum2 %= 255;

    nsum3 = (nsum2*1000)+nsum1;

    _retnl(nsum3);

}

