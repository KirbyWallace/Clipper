/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_QuickEncrypt( cString, nKey ) --> cEncryptStr

PARAMETERS:

cString : String to be encrypted.
nKey    : Numeric key value for offset seed

SHORT:

Quick encryption routine (less secure, but faster).

DESCRIPTION:

k_QuickEncrypt() provides a faster encryption than k_Encrypt() at the expense 
of being easier to decrypt.  Strings encrypted with k_QuickEncrypt() can 
only be decoded with k_QuickDecrypt().

k_QuickEncrypt() returns the original string intact if an error occurs (if 
nKey is not specified or is non-numeric.)

NOTE:



EXAMPLE:

t = k_QuickEncrypt('ABCDEFG',55)

Result:

t = <encrypted string> if no error, or 'ABCDEFG' if nKey is invalid.

******************************************************************************/

FUNCTION k_QuickEncrypt( cString, nKeyVal )
LOCAL    i
LOCAL    cRetVal := ''

if nKeyVal = NIL
    cRetVal = cString
else

    nKeyVal += 95

    for i = 1 to len(cString)
        cRetVal += chr((asc(substr(cString,i,1))+nKeyVal+255-(i*2+3)) % 255 )
    next

endif


RETURN(cRetVal)

