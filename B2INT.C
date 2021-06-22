/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_B2Int(cBinString) --> nInteger

PARAMETERS:

cBinString: a binary string

SHORT:

Convert binary string to integer equivalent

DESCRIPTION:

k_B2Int() converts Binary string to integer equivalent.  This is a "C" function
and is quicker than the Clipper equivalent.

NOTE:

EXAMPLE:

? k_B2Int("1101") // Result: 13

******************************************************************************/

#include <extend.h>

CLIPPER k_b2int(void) {

    char *num = _parc(1);
    int len = _parclen(1)-1;
    int i = 0;
    int j = 0;

    for (j=0 ; len != -1 ; j++) {

        if (num[len--] == '1')
            i += __exponent(2,j);

    }

    _retni(i);
}

int __exponent(int base, int power) {

    int retval = 1;
    int i = 0;

    if (power == 0)
        return(1);

    if (power == 1)
        return(base);

    for (i=1;i<=power;i++) {

        retval *= base;
    }

    return (retval);

}

