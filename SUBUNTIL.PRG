/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_SubUntil( cStr, cFromText, cToText ) --> cString

PARAMETERS:

cStr      : String to extract from
cFromText : String after which to begin extracting cToText  
cToText   : String to stop extracting at when encountered

SHORT:

Return substring between two tokens in a string.

DESCRIPTION:

k_SubUntil() takes an input string and begins extracting a string 
immediatly AFTER the cFromText label up to, but not including the 
cToText string.  It is useful for extracting a parameter or substring 
from another string when you do not know the exact position of the 
desired substring, only that it follows "some text" and ends at some 
text (most likely a white-space character).  k_SubUntil() IS case sensitive. 
 If case is unknown, you should lower() or upper() the input strings. 

An end of string condition will return the string from the requested start 
position up to the end of the string.

If cFromText is empty, the return string begins at the beginning of cStr 
(ie, the first character).

If cToText is empty, the return string includes everything from the 
starting position up to AND including the last character of cStr. 

Thus, if both cFromText and cToText are empty (or NIL) then k_SubUntil() 
will return the entire string.

RETURNS: Sub-String that occurs BETWEEN two delimiting strings.

NOTE:



EXAMPLE:

k_SubUntil('Name: Kirby L. Wallace','Name: ',' ')
Returns: "Kirby"

k_SubUntil('Name: Kirby L. Wallace','L. ',' ')
Returns: "Wallace" even though the cToText never occured

? k_SubUntil('Kirby L. Wallace',,'L.')
Returns: "Kirby" (cToText defaulted to <beginning of string>)

? k_SubUntil('Kirby L. Wallace','Kirby','Wallace')
Returns: " L. "  // note spaces!

? k_SubUntil('Kirby L. Wallace','L. ')  // Note SPACE in "L. "
Returns: "Wallace"

? k_SubUntil('Kirby L. Wallace')
Returns: "Kirby L. Wallace"

******************************************************************************/

FUNCTION k_SubUntil(cStr, cFromText, cToText)

LOCAL i
LOCAL cRet_Val := ''

cFromText = iif(cFromText = NIL, "", cFromText)
cToText = iif(cToText = NIL, "", cToText)


if empty(cFromText)
    i = 1
else
    i = at(cFromText,cStr)+len(cFromText)
endif

if empty(cToText) .and. (cToText != space(len(cToText)))

    cRet_Val = substr(cStr,i)

else

    for i = i TO len(cStr)

        if substr(cStr,i,len(cToText)) = cToText
            exit
        endif

        cRet_val += substr(cStr,i,1)

    next

endif

RETURN(cRet_Val)

