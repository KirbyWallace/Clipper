/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_LineEdKill( cKey, cAlias, cField ) --> nBytesRecovered

PARAMETERS:

cKey   : Unique record key for relational lookups
cAlias : Alias Name of work area for text
cField : Field name in the cALias work area for text

SHORT:

Recycle LineEdit Comments for use by other comments.

DESCRIPTION:

k_LineEdKill() deletes the comments in use for a given parent record
key, effectively recycling them.

See k_LineEdGet() for a full description.

NOTE:



EXAMPLE:

k_LineEdKill(Accounts->CustAccNum,'ACCOUNTS','COMMENTS')

Result: The comments stored in the database aliased as ACCOUNTS, using 
the character field COMMENTS, are recycled for use by other comments.

******************************************************************************/

#include "klipper.ch"

FUNCTION k_LineEdKill(cKey, cAlias, cField)
LOCAL    nRemainder  := 0
LOCAL    nFLen       := 0
LOCAL    nOldArea    := select()
LOCAL    nOldRec     := recno()
LOCAL    acIndexFlds := {}
LOCAL    nNextRec    := 0
LOCAL    i           := 0

k_PushSet(_SET_EXACT,set(_SET_EXACT,FALSE))

SELECT (cAlias)

// get the index key field(s)
acIndexFlds := k_IndexFields()

nFLen = len(fieldget(fieldpos(cField)))-4

if nFLen < 26
    k_Terminate('LineEditSize() Fatal Error - Insufficient Comment Field Length: '+cField)
else

    SEEK (cKey)

    **********************************************************
    *  The following code loop is identical to that used in  *
    *  k_LineEdPut() - Check there for code comments        *
    **********************************************************

    while &(indexkey(indexord())) = trim(cKey) .and. !eof()

        SKIP

        nNextRec = recno()

        SKIP -1

        while !rlock() ; end

        for i = 1 to len( acIndexFlds )

            fieldput(fieldpos(acIndexFlds[i]),repl(chr(219),len(&(acIndexFlds[i]))))

        next

        GOTO nNextRec

    end

endif

if nOldArea != 0
    SELECT (nOldArea)
    GOTO   (nOldRec)
endif

set(_SET_EXACT,k_PopSet(_SET_EXACT))

RETURN(i*nFLen)

