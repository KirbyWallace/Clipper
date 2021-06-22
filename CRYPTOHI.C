/*****************************************************************************
 The Klipper Library, By Kirby L. Wallace.  Copyright (c), 1986-1992
             Wallace Information Systems Engineering


FUNCTION:

k_CryptoHI( @cString, cKey ) --> NIL

PARAMETERS:

cString: String to be encrypted
cKey   : Encryption key

DESCRIPTION:

k_CryptoHI() is an encryption function that offers medium
to "fairly sophisticated" security in favour of medium to "fairly
sophisticated" speed.

Security and speed are proportionate to each other.  The more
secure, the more time consuming the encryption.  So as you move
up in levels of security, you typically move down in speed of
encryption.

Security is a relative term.  Defeating it depends upon skill
of the cracker.  It is important to remember that there are
no 100% fool-proof security systems (no matter what Bill Clinton
and his CLIPPER (chip) administration personnel say.)

NOTE: cString MUST be passed to k_Crypto() BY REFERENCE.  Failure
to do so may yield unpredictable results.

EXAMPLE:

t = "STOP!  Or I shall shout 'STOP!' at you again."

k_Crypto(@t,'PASSWORD')

    Result: t now contains encrypted gibberish.

k_Crypto(@t,'PASSWORD')

    Result: t now contains it's original value

******************************************************************************/
#include <extend.h>

CLIPPER k_CryptoHI(void) {
    

    char *data;
    char *key;

    unsigned int dlen;
    unsigned int klen;

    // the secondary key is named ClipperPrc to make it ambigous to prying eyes
    // you may change this password to anything you like, but it must remain
    // unchanged once you have actually encrypted something with it.  Since
    // this is just an internal password for secondary encryption, I'd
    // recommend changing it to something and then leaving it alone.
    //

    char *ClipperPrc =  "@^@*I^@/@^^S@^@@]@]@]@^A^@^H]]^]S@^@/@b@^@7^E@^@5^A^^r*H]@)@)@^" \
                        "^@^@(^B^D*R^@q^c@*X^@7^B{b^[O^@*Y^@^A^E^@^k^@ru/^^e^@U^G^@)^/@@^" \
                        "@^@*I^^c@*X^@7^B{b^[O^@*Y^@^A^E^@^k^@ru/@/@^^S@^@@]@]@]@^A^@^H]" \
                        "^@^@(^S@^@@]@]@]@^A^@^H]]^]S@^B^D*R^@q^c@*X^@7^B{b^[O^@*Y^@^A^E" ;


    int i = 0;
    int j = 0;
    int k = 0;
    int l = 0;


    data = _parc(1);
    key  = _parc(2);

    dlen = _parclen(1);
    klen = _parclen(2);

    j=0;
    k=0;
    l=0;

    for (i=0;i<dlen;i++) {

        data[i] ^= key[j++];

        for (l=1;l<2500;l+=17) {
            data[i] ^= (l%56);
        }

        for (k = 0;k<250;k++) {
            data[i] ^= ClipperPrc[k];
        }

        if (j == klen)
            j = 0;


    }

    _storclen(data,dlen,1);

}


