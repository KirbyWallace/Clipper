/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x
        Copyright (c), 1994, Wallace Information Systems Engineering            


FUNCTION:

k_Gather(acRecord) --> lSuccess

PARAMETERS:

 acArray : array of field data created by k_Scatter()

SHORT:

Gather array to database fields.  Create array with k_Scatter().

DESCRIPTION:

k_Gather() replaces database fields with array elements in acArray.  Each
element has all the information it needs to determine the correct database
and field that it needs to replace with each element.

k_Gather() returns TRUE if all fields were written correctly or false of
any data is written incorrectly or not at all.  This is done by a
verification read of the data immediately after is it written.  If the
field contents match the array variable contents, success is assumed.

NOTE:

k_Gather() does not impose a record lock UNLESS it must switch to a new
work area to find the target database.  If the target database is current,
you must get a record lock before calling.  In any case, k_Gather() never
releases it's record lock.  You must do this when appropriate.

EXAMPLE:

See k_Scatter() for an example of usage.

******************************************************************************/

#include "klipper.ch"

FUNCTION k_Gather(axRecord)

LOCAL    i
LOCAL    nOldArea := select()
LOCAL    lRetVal  := TRUE


BEGIN SEQUENCE

    for i = 1 to len(axRecord)

        // change SRCE to NIL to discard changes

        if axRecord[i,SCAT_SRCE] != NIL

            // discard changes if attribute is READONLY
            // READONLY  = .T.
            // READWRITE = .F.
            // Thus !READWRITE = .T. (it's a PP trick!)
            //

            if !axRecord[i,SCAT_ATTR]

                if alias() != axRecord[i,SCAT_SRCE]

                    SELECT (axRecord[i,SCAT_SRCE])

                    if !rlock()
                        lRetVal = FALSE
                        BREAK
                    endif

                endif

                if fieldput(fieldpos(axRecord[i,SCAT_NAME]),axRecord[i,SCAT_DATA]) != axRecord[i,SCAT_DATA]

                    lRetVal = FALSE
                    BREAK

                endif


            endif

        endif

    next

END SEQUENCE

if nOldArea != 0
    SELECT (nOldArea)
endif


RETURN(lRetVal)

