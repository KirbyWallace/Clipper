/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_LineEdSize(cKey, cAlias, cField) --> nCommentSize

PARAMETERS:

cKey   : Unique record key for relational lookups
cAlias : Alias Name of work area for text
cField : Field name in the cALias work area for text

SHORT:

Determine size of a comment stored in a comment base.

DESCRIPTION:

k_LineEdSize() returns the length of a comment that is stored in a
LineEdit database.

See k_LineEdGet() for a full description.

NOTE:



EXAMPLE:

k_LineEdSize(Accounts->CustAccNum,'ACCOUNTS','COMMENTS')

Result: The comments stored in the database aliased as ACCOUNTS, using 
the character field COMMENTS, is examined and it's size is returned.

That is: ACCOUNTS->Comments is evaluated for all it's records and 
the cumulative size is returned.

******************************************************************************/

#include "klipper.ch"

FUNCTION k_LineEdSize(cKey, cAlias, cField)
LOCAL    nSize      := 0
LOCAL    nRemainder := 0
LOCAL    nFLen      := 0
LOCAL    nOldArea   := select()
LOCAL    nOldRec    := recno()


k_PushSet(_SET_EXACT,set(_SET_EXACT,FALSE))

SELECT (cAlias)

nFLen = len(fieldget(fieldpos(cField)))-4

if nFLen < 26
    k_Terminate('LineEditSize() Fatal Error - Insufficient Comment Field Length: '+cField)
else

    SEEK (cKey)

    if found()

        while &(indexkey(indexord())) = trim(cKey) .and. !eof()
            nSize++
            SKIP
        end

        SKIP -1

        nRemainder = len(trim(fieldget(fieldpos(cField))))-4

        // nSize-1 because I accounted for the last one above.
        // unrelated to the actual comment text.

        nSize = ((nSize-1)*nFLen)+nRemainder

    endif

endif

if nOldArea != 0
    SELECT (nOldArea)
    GOTO   (nOldRec)
endif

set(_SET_EXACT,k_PopSet(_SET_EXACT))

RETURN(nSize)

