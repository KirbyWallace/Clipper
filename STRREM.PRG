/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_StrRem( cString, cRemove ) --> cString

PARAMETERS:

cString : String to Remove Characters from
cRemove : String to Remove

SHORT:

Remove characters from a string wherever they occur.

DESCRIPTION:

k_StrRem() removes one string from another, wherever it first occurs.

NOTE:



EXAMPLE:

String1 = 'THIS IS NOT A STRING"
String2 = k_StrRem(String1," NOT")

Result: String2 = "THIS IS A STRING"

The following example will effectively remove ALL "A"'s from the string:

String1 = "A BIRD IN THE HAND IS..."

while String1 != k_StrRem(String1,'A') ; end

Result: When the loop exits, String1 will be "A BRD N THE HAND S..."

******************************************************************************/
FUNCTION k_StrRem(cString,cRemove)
LOCAL cRet_Val := ''

if cString != NIL

    if cRemove $ cString
        cRet_Val = stuff(cString,at(cRemove,cString),len(cRemove),'')
    else
        cRet_Val = cString
    endif

else
    cRet_Val = ''
endif

RETURN(cRet_Val)

