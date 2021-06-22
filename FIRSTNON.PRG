/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_FirstNon( cString ) --> cString

PARAMETERS:

cString  : String to test

SHORT:

Return string up to but not including first non-numeric character.

DESCRIPTION:

k_FirstNon() Returns a substring of the string passed in cString up to but 
not including the Non-AlphaNumeric character.

NOTE:

The UNDERSCORE character is considered AlphaNumeric in this case. Thus, A..Z 
a..z 0...9 and _ are the only allowed characters.


EXAMPLE:

t = k_FirstNon('ABC&D')
Result: t = 'ABC'


t = k_FirstNon('XXX&YYYYY')
Result: t = 'XXX'


t = k_FirstNon('*ABCDEFG')
Result: t = ''

******************************************************************************/

FUNCTION k_FirstNon(cString)
LOCAL    i

for i = 1 to len(cString)
    if !( upper(substr(cString,i,1)) $ 'ABCDEFGHIJKLMNOPQRSTUVWXYZ_1234567890')
        exit
    endif
next

RETURN(substr(cString,1,i-1))

