/*****************************************************************************
 The Klipper Library, By Kirby L. Wallace.  Copyright (c), 1986-1992
             Wallace Information Systems Engineering


FUNCTION:

k_Crypto( @cString, cKey ) --> NIL

PARAMETERS:

cString: String to be encrypted
cKey   : Encryption key

DESCRIPTION:

Identical to _CryptoHI() in syntax and description.

k_Crypto() is a fast encryption function that offers lighter
security in favour of higher speed.

NOTE: cString MUST be passed to _Crypto() BY REFERENCE.  Failure
to do so may yield unpredictable results.

******************************************************************************/
#include <extend.h>

CLIPPER k_Crypto(void) {
    

    char *data;
    char *key;

    unsigned int dlen;
    unsigned int klen;


    int i = 0;
    int j = 0;


    data = _parc(1);
    key  = _parc(2);

    dlen = _parclen(1);
    klen = _parclen(2);


    j=0;

    for (i=0;i<dlen;i++) {

        data[i] ^= key[j++];

        data[i] ^= (i%256);

        if (j == klen)
            j = 0;


    }

    _storclen(data,dlen,1);

}
