/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_arraylen(axArrayName) --> nNumberElements

PARAMETERS:

axArray:  The name of an array whose elements are to be counted

SHORT:

Count number of array elements that actually contain values.

DESCRIPTION:

k_ArrayLen() counts the number of elements in the array, axArrayName, and
the length of the array without undefined elements

NOTE:

EXAMPLE:

LOCAL aArray[10]

aArray[1] = "One"
aArray[2] = "Two"
aArray[5] = "Five"

? k_arraylen(aArray) // 3

******************************************************************************/
#include <extend.h>

CLIPPER k_arraylen(void) {

    int numelems = _parinfa(1,0);
    int retval = 0;
    int i;

    for (i=1;i<=numelems;i++) {

        if ( _parinfa(1, i) )
            retval++;

    }

    _retni(retval);

}

CLIPPER k_arraydef(void) {

    _retni(_parinfa(1,0));

}

