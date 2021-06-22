/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_StrAdd( cString, cInsert, nPos ) --> cString

PARAMETERS:

cString : String to be added to
cInsert : String to insert (or append)
nPos    : Position at which to insert the insert string

SHORT:

Insert one string into another at a specified point.

DESCRIPTION:

k_StrAdd() inserts one string into another at a specified location.

If nPos is not passed, or if nPos is greater than the length of cString, 
then cInsert is appended to cString, else cInsert is inserted into cString 
at position nPos.  If cString is empty, the above rule applies since 
the insert string will be of greater length and the return value 
will effectively be the cInsert string.

NOTE:



EXAMPLE:

String1 = 'THIS IS A STRING'
STRING2 = ' NOT'
String3 = k_StrAdd(String1,String2,8)

Result: string3 = "THIS IS NOT A STRING"

Another example:

String1 = 'THIS IS A STRING'
String2 = k_StrAdd(String1," NOT",8)

Result: string2 = "THIS IS NOT A STRING"

******************************************************************************/
FUNCTION k_StrAdd(cString,cInsert,nPos)
LOCAL cRet_Val := ''

if cString = NIL
    cString = ''
endif

if cInsert = NIL
    cInsert = ''
endif

if nPos = NIL
    nPos = len(cString)+1
endif


if nPos > len(cString)
    cRet_Val = cString+cInsert
else
    cRet_Val = substr(cString,1,nPos-1)+cInsert+substr(cString,nPos)
endif


RETURN(cRet_Val)

