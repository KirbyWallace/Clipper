/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_QuickDecrypt( cString, nKey ) --> cDecryptStr

PARAMETERS:

cString : String to be decrypted.
nKey    : Numeric key value for offset seed

SHORT:

Quick Decrypt for _QEncrypt() values.

DESCRIPTION:

k_QuickDecrypt() provides a faster decryption than k_Encrypt() at the expense 
of being easier to decrypt.  It works ONLY on strings created by 
k_QuickEncrypt().

k_QuickDecrypt() returns the original string intact (still encrypted) if 
an error occurs (if nKey is not specified or is non-numeric).

NOTE:



EXAMPLE:

t = k_QuickEncrypt('ABCDEFG',55)
t = k_QuickDecrypt(t,55)

Result:

t = 'ABCDEFG'

******************************************************************************/

FUNCTION k_QuickDecrypt( cString, nKeyVal )
LOCAL    i
LOCAL    cRetVal := ''


if nKeyVal = NIL

    cRetVal = cString

else

    nKeyVal += 95

    for i = 1 to len(cString)
        cRetVal += chr((asc(substr(cString,i,1))-nKeyVal+255+(i*2+3)) % 255 )
    next

endif


RETURN(cRetVal)

