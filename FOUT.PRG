/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_FOut( cFieldName, cPassword ) --> cDBFieldData

PARAMETERS:

cFieldName : Field name to retrieve contents from
cPassword  : Encryption password (Optional

SHORT:

Retrieve a database field written by k_FIn() with optional decryption.

DESCRIPTION:

k_FOut() reads a database field, optionally decrypting with the contents of 
cPassword (if specified).

If cPassword is no specified, the contents of the field are returned "as is."

NOTE:

See k_FIn() for more information.

EXAMPLE:

k_FOut('CustName','PASSWORD')

Result: the contents of the CustName field are returned after being decrypted 
with the "PASSWORD" password.

If the password was not specified when k_FIn() was used, then it should not be 
specified for k_FOut().

Passwords is passwords, after all.  By the way, passwords are ALWAYS case 
sensitive!

******************************************************************************/

FUNCTION k_FOut(cFieldName,cPassword)
LOCAL    Ret_Val := ''

if type(cFieldName) == 'C'

    if !empty(&cFieldName)

        if cPassword != NIL
            Ret_Val = space(k_LeadSpace(&cFieldName))+k_Encrypt(fieldget(fieldpos(&cFieldName)),cPassword) + space(k_TrailSpace(&cFieldName))
        else
            Ret_Val = fieldget(fieldpos(&cFieldName))
        endif

    else
        Ret_Val = space(len(&cFieldName))

    endif

else
    Ret_Val = &cFieldName

endif

RETURN(Ret_Val)

