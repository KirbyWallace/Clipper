/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_WhichElement( aArray, cString, lBegins ) --> nElementNumber

PARAMETERS:

aArrayName : Array to search
cString    : String to search for

SHORT:

Scan an array looking for the element that contains the specified value.

DESCRIPTION:

k_WhichElement() searches a character array for a particular value and 
returns the element number that matches the search criteria or zero if not 
found.

If lBegins is TRUE, cString must BEGIN at position 1. (DEFAULT)
If lBegins is false, cString may occur anywhere in the element.

NOTE:

This function differs from ASCAN() only in that it will return the element 
number that contains the specified data ANYWHERE in the element (not just at 
the beginning).  It can be made to operate identically to ASCAN() by 
specifying TRUE in lBegins.

EXAMPLE:

#include "klipper.ch"

PRIVATE Names[5]
names[1] = 'John'
names[2] = 'James'
names[3] = 'Jenifer'
names[4] = 'Jeremy'
names[5] = 'Jacob'

t = k_WhichElement(Names,'Jenifer',TRUE)
Result: t = 3

t = k_WhichElement(Names,'Jenifer')
Result: t = 3

t = k_WhichElement(Names,'Frank')
Result: t = 0

t = k_WhichElement(Names,'rem',FALSE)
Result: t = 4

******************************************************************************/

FUNCTION k_WhichElement(aArrayName, cString, lBegins )
LOCAL    i
LOCAL    nRet_Val := 0

if lBegins = NIL
    lBegins = .t.
endif

for i = 1 to len(aArrayName)

    if lBegins
        if lower(cString) == lower(aArrayName[i])
            nRet_Val = i
            EXIT
        endif
    else
        if lower(cString) $ lower(aArrayName[i])
            nRet_Val = i
            EXIT
        endif
    endif
next

RETURN(nRet_Val)
