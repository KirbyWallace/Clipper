/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_FIn( cFieldName, cFieldVal, cPassword ) --> NIL

PARAMETERS:

cFieldName: Name of database field to write data
cFieldVal : Data to be written to database field
cPassword : Encryption Password (Optional)

SHORT:

Write data to database field, optionally with encryption.

DESCRIPTION:

k_FIn() writes data to a database field.

If cPassword is specified, character fields are encrypted before writting.  
Encrypted fields maintain both leading and trailing spaces.  That is, if the 
value "     KIRBY     " is written and a password is specified, the result 
will be something to the effect of "     @f&3_     ".  The leading and 
trailing spaces are not included in the encryption because doing so makes 
breaking of the encryption much easier.  

The k_FOut() function will similarly restore leading and trailing spaces.

Non-Character fields are not encrypted.

NOTE:



EXAMPLE:

t = "This is a test"

k_FIn('TESTFIELD',t,'PASSWORD')

******************************************************************************/

FUNCTION k_FIn(cFieldName,cFieldVal,cPassword)


*********************************************************************************************
* if cPassword is NIL it will be passed as NIL causing k_Encrypt() to use a default password *
*********************************************************************************************

if type(cFieldName) == 'C'

    if !empty(cFieldVal)

        ************************************************************************************
        * LeadSpace and TrailSpace preserve any leading and trailing spaces that are being *
        * placed into the database field so that only actual data is encrypted and blanks  *
        * are left alone                                                                   *
        ************************************************************************************

        if cPassword != NIL
            fieldput(fieldpos(cFieldName), space( k_LeadSpace(cFieldVal))+k_Encrypt(alltrim(cFieldVal),cPassword)+space(k_TrailSpace(cFieldVal)) )
        else
            fieldput( fieldpos(cFieldName), cFieldVal )
        endif

    else

        fieldput( fieldpos(cFieldName), '' )

    endif
else

    ******************************************
    * non-character fields are not encrypted *
    ******************************************

    fieldput( fieldpos(cFieldName), cFieldVal )

endif

RETURN(NIL)

