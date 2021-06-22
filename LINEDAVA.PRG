/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_LineEdAvail(cAlias, cField) --> nBytesAvail

PARAMETERS:

cAlias : Alias Name of work area for text
cField : Field name in the cALias work area for text

SHORT:

Determine the number of recyclable bytes in a LineEdit comment database.

DESCRIPTION:

k_LineEdAvail() returns the amount (number of bytes) of recycleable
storage space in the specified LineEdit database.  This represents how 
many additional bytes of storage may be added to the file without it 
growing by even one byte.

See k_LineEdGet() for a full description.

NOTE:



EXAMPLE:

k_LineEdAvail('ACCOUNTS','COMMENTS')

Result: The LineEdit database specified by cAlias is examined and the 
number of bytes of free space it contains in the cField field is returned.

In this case, the LineEdit database is open and aliased as ACCOUNTS and 
the field name is COMMENTS.

******************************************************************************/

#include "klipper.ch"

FUNCTION k_LineEdAvail(cAlias, cField)
LOCAL    nSize       := 0
LOCAL    nFLen       := 0
LOCAL    nKeyLen     := 0
LOCAL    acIndexFlds := {}
LOCAL    i
LOCAL    nOldArea    := select()
LOCAL    nOldRec     := recno()

k_PushSet(_SET_EXACT,set(_SET_EXACT,FALSE))

SELECT (cAlias)

// check size of comment field
nFLen = len(fieldget(fieldpos(cField)))-4

// get the index key field(s)
acIndexFlds := k_IndexFields()

// note length of each
for i = 1 to len(acIndexFlds)
    nKeyLen += len(&(acIndexFlds[i]))
next

SEEK repl(chr(219),nKeyLen)

if found()

    while repl(chr(219),nKeyLen) = &(indexkey(indexord())) .and. !eof()
        nSize++
        SKIP
    end

    nSize = (nSize*nFLen)

endif

if nOldArea != 0
    SELECT (nOldArea)
    GOTO   (nOldRec)
endif

set(_SET_EXACT,k_PopSet(_SET_EXACT))

RETURN(nSize)

