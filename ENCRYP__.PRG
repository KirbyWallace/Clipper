/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Encrypt( cEncStr, cKey ) --> cEncryptStr

PARAMETERS:

cEncStr : String to be encrypted.
cKey    : Character String. Code to be used as encrypt key (optional)

SHORT:

Encrypt a string.

DESCRIPTION:

k_Encrypt() employs a typical XOR encryption algorythm.

NOTE:



EXAMPLE:

t = k_Encrypt('ABCDEFG')          // t = bit-soup
t = k_Encrypt(t)                  // t = ABCDEFG

-and with optional key-

t = k_Encrypt('SESAME','CHEESE')  // t = bit-soup simmered
                                 //     in 'CHEESE' sauce

? k_Encrypt(t)                    // still bit-soup, would you like
                                 // a napkin?

? k_Encrypt(t,'CHEESE')           // t = 'SESAME'

*****************************************************************

IMPORTANT: Due to the nature of an XOR encryption, especially 
this implementation, if you specify a NULL string as the encryption 
key, essentially NOTHING will happen.  The encrypted result will be 
exactly the same as the data being encrypted! 

k_Encrypt() does NOT check to see whether you have done this! (After all, 
you know what you are doing, right?)

This will not endanger your data, because if you do this twice, (one 
to encrypt and again to decrypt, the same string will be returned both 
times).

You may wish to look into _Crypto(), which will give a unique encryption 
even if you use a NULL string.  It is also MUCH faster, as it is written 
in "C", not Clipper.

Not also that an embedded NULL in an otherwise non-NULL key will not 
cause this.  This phenomenon occurs only when the entire key is a NULL 
string.  Tries ta be more smarts, wid dis.  OK?

*****************************************************************

cKey is optional.  If not specified, an internal password is used by default. 

Remember also that concatenated values must be evaluated separately. If 
you evaluate two fields like so:

k_Encode(user+system)

    and

k_Encode(user)+k_Encode(system)

The two methods return different values.  Why?  Because when you evaluate 
the two fields concatenated, the decryption key does not begin fresh with 
the second value but continues decrypting the entire concatenanted value 
until done. 

Subservient functions k_Encode() and k_Decode() can be used interchangably 
with k_Encrypt(), since they all do the same thing.  k_Encode() and 
k_Decode() simply pass along to k_Encrypt() what was passed to them. The 
names Encode and Decode make things a little more easy to handle.

******************************************************************************/

FUNCTION k_Encrypt(cEncStr,cKey)
LOCAL    cResult := ''
LOCAL    i
LOCAL    k
LOCAL    nKey
MEMVAR   Fi_Fo

**********************************************************************************
* The source code to this function is not to be released with the library source *
*                                                                                *
* If it is requested, remove the default password before sending to purchaser    *
* and include a note instructing them to insert one of their own.                *
*                                                                                *
* (i.e., cKey = 'DEFAULT_PASSWORD_HERE' )                                        *
*                                                                                *
* Also inform user that is is IMPORTANT that once an internal passowrd is chosen *
* it cannot be changed, ever, without losing compatibility with previous versions*
* that used the old password.                                                    *
*                                                                                *
**********************************************************************************

if cKey = NIL

    cKey = '@^@*I^@/@^^S@^@@]@]@]@^A^@^H]]^]S@^@/@b@^@7^E@^@5^A^^r*H]@)@)@^'+ ;
           '^@^@(^B^D*R^@q^c@*X^@7^B{b^[O^@*Y^@^A^E^@^k^@ru/^^e^@U^G^@)^/@@^'+ ;
           '@^@*I^^c@*X^@7^B{b^[O^@*Y^@^A^E^@^k^@ru/@/@^^S@^@@]@]@]@^A^@^H]'+ ;
           '^@^@(^S@^@@]@]@]@^A^@^H]]^]S@^B^D*R^@q^c@*X^@7^B{b^[O^@*Y^@^A^E'

endif

k = 0

for i = 1 to len(cEncStr)

    k = iif(k=len(cKey),1,k+1)

    nKey := k_IToB(asc(substr(cKey,k,1)),8)

    cResult += chr(k_BtoI(k_XOR(k_IToB(asc(substr(cEncStr,i,1)),8),nKey)))

next

RETURN(cResult)


FUNCTION k_Encode(a,b)
RETURN(k_Encrypt(a,b))

FUNCTION k_Decode(a,b)
RETURN(k_Encrypt(a,b))

