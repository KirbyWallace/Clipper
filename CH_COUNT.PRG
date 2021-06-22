/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ChCount( cInChar, cInStr ) --> nInteger

PARAMETERS:

cInChar : Character(s) to count
cInStr  : String to search

SHORT:

Count the number of times a character (or string) occurs in a string.

DESCRIPTION:

k_ChCount() counts the number of times that a given character or character
string occurs in another given string.

NOTE:

k_ChCount() IS case sensitive.

EXAMPLE:

t = k_ChCount('A','ABCADEFAGHIAJKL')

    Result: t = 4

t = k_ChCount('AD','ABCADEFADHIAJKL')

    Result: t = 2

t = k_ChCount('AA','AAAA')

    Result: t = 2

    Note that once a set of characters have been counted, they are excluded
    from any further count.

t = k_ChCount('a','ABCADEFAGHIAJKL')

    Result: t = 0 (REMEMBER: Case Sensitive)

******************************************************************************/

FUNCTION k_ChCount(cInChars,cInStr)
RETURN( (len(cInStr)-len(strtran(cInStr,cInChars,""))) / (len(cInChars)) )

