/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_FIOConvert( cConvVal, cPassword ) --> cString

PARAMETERS:

cConvVal  : Value to convert
cPassword : Encryption Password (Optional)

SHORT:

Decrypt a value encrypted by the k_FIn() Function.

DESCRIPTION:

When k_FIn() writes a database field with encryption, the k_FOut() function can 
retrieve it when the field is read.  However, you may occasionally want to 
encrypt the value without actually writting it to the field in order to 
examine it first.

This is the purpose of _FIOConvert().  It will return the same encryption 
string that k_FIn() will create, but without writting the database field.

If cPassword is not specified, then the character data passed is returned 
unchanged.

NOTE:

Note: There is no param checking done in this function.

You will cause a runtime error if you pass a non-character convert value. 
k_FIn() and k_FOut() check parameters for character values because they are 
called automatically in many cases, but YOU exercise all control of this 
func.

EXAMPLE:

_FIOConvert('THIS IS A TEST','PASSWORD')

Returns: an encrypted string if password is not blank (which in this case it 
isn't).

******************************************************************************/
FUNCTION k_FIOConvert(cConvVal,cPassword)
LOCAL    cRetVal

if cPassword != NIL
    cRetVal = (iif(!empty(cConvVal),space(k_LeadSpace(cConvVal))+k_Encrypt(alltrim(cConvVal),cPassword)+space(k_TrailSpace(cConvVal)),space(len(cConvVal))))
else
    cRetVal = cConvVal
endif

RETURN(cRetVal)

