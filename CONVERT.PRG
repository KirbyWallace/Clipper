/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Convert( cString, cException ) --> cString

PARAMETERS:

cString    : String to Convert
cException : Character Exceptions

SHORT:

Strip all non-alphanumeric from a string (with optional exceptions).

DESCRIPTION:

k_Convert() strips characters from a string, returning only the characters 
that are NOT included in:

Omit_Chars : <SPACE> _!$^*,-=+\|/`~{}.':<>%"&#@()`?][]

I.E., Convert strips all non-alphanumeric characters.

cException can be a string of characters to leave in the string. If 
cException = ' $()' then SPACE $, (, and ), will be left in the string, even 
though they normally would be removed, and all other punctuation marks in 
omit_chars will be removed.

cException is optional if unspecified, no exception is made.

NOTE:



EXAMPLE:

t = k_Convert('A B C D E F G !$^*,-=+\|/`~{}()`?][]Z')

Result: t = 'ABCDEFGZ'

t = k_Convert( 'A B C D E F G !$^*,-=+\|/`~{}()`?][]Z', '$()' )

Result: t = 'ABCDEFG$()Z'

******************************************************************************/

FUNCTION k_Convert(cStr, cException)
LOCAL    cOutStr
LOCAL    cOmit_Chars
LOCAL    i

cOutStr = ''

cStr = alltrim(cStr)

cOmit_Chars=[ _!$^*,-=+\|/`~{}.':<>;%"&#@()`?]+'[]'

if cException != NIL
    for i = 1 to len(cException)
        cOmit_Chars = strtran(cOmit_Chars,substr(cException,i,1),'')
    next i
endif

for i = 1 to len(cStr)
    if !(substr(cStr,i,1) $ cOmit_Chars)
        cOutStr += substr(cStr,i,1)
    endif
next

RETURN(cOutStr)

