/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_LineEdPut( cKey, cAlias, cField, cString ) --> nBytesWritten

PARAMETERS:

cKey   : Unique record key for relational lookups
cAlias : Alias Name of work area for text
cField : Field name in the cALias work area for text
cString: Text to PUT

SHORT:

Write LineEdit Comments to comment base.

DESCRIPTION:

k_LineEdPut() writes a character string (cString) to records the
open database that is specified in cAlias and indexed on cKey.  The field 
that the string spans is cField.

SEE k_LineEdGet() for a full discussion.

NOTE:



EXAMPLE:

See k_LineEdGet() for complete discussions and examples.

******************************************************************************/
#include "klipper.ch"

FUNCTION k_LineEdPut( cKey, cAlias, cField, cString, cPassword )

LOCAL    nRec := recno()
LOCAL    nArea := select()
LOCAL    i := 1, j := 1, k := 1
LOCAL    nKeyLen := 0
LOCAL    axRecSnap := {}
LOCAL    acTemp := {}
LOCAL    cPutStr := ""
LOCAL    nFLen := 0, nFCount := 0
LOCAL    nNextRec
LOCAL    acIndexFlds := {}


FIELD    Serno, Name, Comment

cPassword = iif(cPassword = NIL .or. empty(cPassword), 'DATAKEY',cPassword)

k_PushSet(_SET_EXACT,set(_SET_EXACT,FALSE))

BEGIN SEQUENCE

if empty(cKey)
    BREAK
endif

cString = trim(cString) ; k_Crypto(@cString,cPassword)

SELECT (cAlias)


// get the index key field(s)
acIndexFlds := k_IndexFields()

// note length of each
for i = 1 to len(acIndexFlds)
    nKeyLen += len(&(acIndexFlds[i]))
next

SEEK trim(cKey)

if !found()


    APPEND BLANK

    j = 0

    for i = 1 to len(acIndexFlds)

        fieldput(  fieldpos(acIndexFlds[i]),substr(cKey,1+j,len(&(acIndexFlds[i])))  )

        j += len(&(acIndexFlds[i]))

    next


endif

    nFLen = len(fieldget(fieldpos(cField)))-4  // num of chars in the specified comment text field minus the reserved bytes

    if nFLen < 26
        k_Terminate('LineEditPut() Fatal Error - Insufficient Comment Field Length: '+cField)
    endif

    nFCount = fcount()

    for k = 1 to nFCount

        aadd(axRecSnap,fieldget(k))

    next


    ******************************************************************************************************************************
    * Fill as many records as are available for this key...
    ******************************************************************************************************************************

    i = 1
    j = 1

    while &(indexkey(indexord())) = trim(cKey) .and. ( i <= len(cString) ) .and. !eof()


            ***********************************
            * wait for and ensure record lock *
            ***********************************

            while !rlock() ; end

            **************************************************************
            * Get as much as will fit field and inc counter by that much *
            **************************************************************

            * using base 36, which should take us from 0..9, A..Z for out char set.

            cPutStr = padl(k_BaseX2BaseY(ltrim(str(j++)),10,36),4,chr(26))+substr(cString,i,nFLen)

            i += nFLen

            ***************************
            * put that into the field *
            ***************************

            fieldput(fieldpos(cField),cPutStr)


            * OLD EXIT WAY if i >= len(cString) ; EXIT ; endif

            SKIP

    end

    ******************************************************************************************************************************
    *
    * Here, either the string is completely written, or there is more to be written.  If completely written, this section
    * is skipped and the delete/repl section is next.  If not completely written, then we first look for recyclable records.
    * If there is a recyclable record it is filled.  If not, blanks are appended and until the string is completely written.
    *
    * Remember that the "j" sequence counter carries over from the above loop into the next
    *
    ******************************************************************************************************************************

    while i <= len(cString)

            SEEK repl(chr(219),nKeyLen)

            if found()

                *****************************************************************************************************************
                * REPLACE EXISTING RECORDS WHILE MORE STRING
                *****************************************************************************************************************

                ***********************************
                * wait for and ensure record lock *
                ***********************************

                while !rlock() ; end

                *************************************************************************************
                * Write the record's key index fields with values obtained from the record snapshot *
                *************************************************************************************

                for k = 1 to nFCount

                    fieldput(k,axRecSnap[k])

                next

                **********************************************************************
                * Put as much of the string as will fit this field, and inc counter  *
                **********************************************************************

                cPutStr = padl(k_BaseX2BaseY(ltrim(str(j++)),10,36),4,chr(26))+substr(cString,i,nFLen)

                fieldput(fieldpos(cField),cPutStr)

                i += nFLen

            else

                *****************************************************************************************************************
                * APPEND NEW RECORDS WHILE MORE STRING
                *****************************************************************************************************************



                APPEND BLANK

                if !neterr()

                    *************************************************************************************
                    * Write the record's key index fields with values obtained from the record snapshot *
                    *************************************************************************************

                    for k = 1 to nFCount
                        fieldput(k,axRecSnap[k])
                    next

                    **********************************************************************
                    * Put as much of the string as will fit this field, and inc counter  *
                    **********************************************************************

                    cPutStr = padl(k_BaseX2BaseY(ltrim(str(j++)),10,36),4,chr(26))+;
                              substr(cString,i,nFLen)

                    fieldput(fieldpos(cField),cPutStr)

                    i += nFLen

                else

                    ***********************************************
                    * Fail the process when an append blank fails *
                    ***********************************************

                    BREAK

                endif

            endif

            SKIP

    end



    ******************************************************************************************************************************
    * by this point, the string has definately been completely written.  We now delete/repl the remaining fields for this key.
    ******************************************************************************************************************************

    // acTemp = k_IndexFields()

    while &(indexkey(indexord())) = trim(cKey) .and. !eof()


        ****************************************************************************************************************
        * In order to get to the next record from here, we will have to note where it is now, for once we overwrite    *
        * the key field area of THIS record THIS record will move and a subsequent SKIP from THIS record will take us  *
        * to the land of "marmalade skies" (ie, places unknown, because once the logical order changes, a SKIP will    *
        * most likely take us to some place other than it would RIGHT NOW.                                             *
        ****************************************************************************************************************

        SKIP

        nNextRec = recno()

        SKIP -1

        **********************************************************************************************************
        * OK.  We are back at original record, and we know where the next logical record is and can calc back    *
        * to it later...                                                                                         *
        **********************************************************************************************************

        ***********************************
        * wait for and ensure record lock *
        ***********************************

        while !rlock() ; end

        for i = 1 to len( acIndexFlds )

            fieldput(fieldpos(acIndexFlds[i]),repl(chr(219),len(&(acIndexFlds[i]))))

        next

        GOTO nNextRec

    end

END SEQUENCE

///////////////////////////////////////
// clean up and restore work areas
///////////////////////////////////////

GOTO nRec

if nArea != 0
    SELECT (nArea)
end

set(_SET_EXACT,k_PopSet(_SET_EXACT))

RETURN(NIL)

