/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ChrLimit( cVar, cChar, nPercent ) --> lExceedsPercent

PARAMETERS:

cVar    : String Variable to check
cChar   : Specific character to check
nPercent: Cutoff percentage at which to return TRUE

SHORT:

Determine if a string is composed of n% or more of any given character.

DESCRIPTION:

k_ChrLimit() checks to see if the specified character cChar composes 
nPercent or more of the characters in cVar.  If it does, then the 
function returns TRUE. If not, FALSE.

If cChar is not specified (is empty() or NIL), then the function returns 
TRUE if ANY single character, of all the characters in the string, 
composes nPercent or more of the total characters.

NOTE:

k_ChrLimit() is really just a "breaking point" function.  It triggers a true 
or false condition in response to certain frequencies of characters in 
strings.  It's purpose is not to collect statistical data about char 
distribution in a string.  Adding such capability would severely slow the 
process down.

See _ChrPercent() for a function that does more with the distribution and of 
percentages of individual characters in a string.  It will, among other 
things, give you the percentage ratio of each character in the string.

EXAMPLE:

cString = 'ABCDEFGHIJ'

? k_ChrLimit(cString,'A',50)    // .F.
? k_ChrLimit(cString,'A',10)    // .T.
? k_ChrLimit(cString,'',20)     // .F.
? k_ChrLimit(cString,,10)       // .T.


In this last example, ALL of the characters are >= 10% of the total chars.  
Notice that without specifying cChar, you do not know WHICH character exceeds 
the percentage limit, only that one character does.


cString := '************ TEXT FILE *************'

? k_ChrLimit(cString,,50)   // .T.

In this example, the "*" composes 69% of the characters and thus exceeds 
our cutoff limit of 50%.

? k_ChrLimit(cString," ",50)   // .F.

In this example, we specifically asked to check the SPACE character.  
It composes only 8% of the total characters.

? k_ChrLimit(cString," ",1)   // .T. 

The three spaces comprise more than 1% of the string's characters.

******************************************************************************/
#include "klipper.ch"

FUNCTION k_ChrLimit(cVar, cChar, nPercent)
LOCAL    i := 0
LOCAL    x, y, z
LOCAL    lRetVal := FALSE
LOCAL    aChars[256]

BEGIN SEQUENCE

if ( (cChar != NIL) .and. (!empty(cChar)) )

    x = k_ChCount(cChar,cVar)

    if (x/len(cVar))*100 >= nPercent
        lRetVal = TRUE
    endif

    BREAK

else

    afill(aChars,0)

    for i = 1 to len(cVar)

        aChars[asc(substr(cVar,i,1))+1]++

    next

    // note that after sorting, there is no way of knowing WHICH character
    // there is the most of.  The one at the bottom is just whichever
    // one appeared most frequently, although by this time, there is no
    // way to know which.  But that wasn't the purpose, and adding that
    // ability would have slowed the process.

    asort(achars)

    if (aChars[256]/len(cVar))*100 >= nPercent
        lRetVal = TRUE
    endif

endif

END SEQUENCE

RETURN(lRetVal)

