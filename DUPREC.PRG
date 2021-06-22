/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_DupRec( cSource_Area, cTarget_Area, l_move, l_Append ) --> lAppendStatus

PARAMETERS:

cSource_Area : Alias of area to copy FROM (If Blank, assumed current area)

cTarget_Area : Alias of area to copy TO (If blank, assumed current area)

l_Move   : TRUE = Copy and Delete from Source Area (MOVE)
         : FALSE = Copy but do not delete in Source area (COPY) (DEFAULT)

l_Append : TRUE = Append Record to TARGET->EOF DEFAULT
         : FALSE = REPLACE Current Target Record

SHORT:

Copy, optionally MOVE, records between work areas.

DESCRIPTION:

k_DupRec() copies (and optionally MOVES) records from one database to another. 

The source and target databases must be specified by ALIAS.  Source fields
that do not exist in the target database are ignored.

If l_Move = TRUE, the Source record is deleted after being copied to the 
Target Record, effecting a MOVE.  If l_Move = FALSE, then the Source record 
is retained. 

If l_Append = TRUE, a blank record is appended to the end of the Target 
Database and the Source record is copied to this appended record.  If 
l_Append = FALSE, the Source record is copied onto the current record in the 
Target database, overwriting it!!! This is useful for updating records in one 
database with new information in another.  You will need to SEEK the desired 
Target Record before calling k_DupRec() in this case.

k_DupRec() returns FALSE if the Target Area cannot be appended to, otherwise 
it returns TRUE.

NOTE:



EXAMPLE:

Select 1
USE data1 ALIAS First

Select 2
USE data2 ALIAS Second

Select 1

GOTO TOP
k_DupRec('FIRST','SECOND',.t.)

Result: All common fields from the top record in data1 are copied
to data2, and the data1 record is deleted.


Select 1
USE data1 ALIAS First

GOTO TOP
k_DupRec()


Result: Record is duplicated WITHIN data1, resulting in TWO records in 
the same database.

******************************************************************************/
#include "klipper.ch"

FUNCTION k_DupRec(cSourceArea, cTargetArea, l_Move, l_Append)
LOCAL    nOldArea := SELECT()
LOCAL    nOldRec  := RECNO()
LOCAL    i, j
LOCAL    xData

LOCAL    cSourceField, cTargetField
LOCAL    cSourceType,  cTargetType
LOCAL    nSourceRec,   nTargetRec

LOCAL    lRetVal := .t.

l_Move   = iif(l_Move   == NIL,.f.,l_Move)
l_Append = iif(l_Append == NIL,.t.,l_Append)

BEGIN SEQUENCE

    if cSourceArea = NIL
        cSourceArea = alias(select())
    endif

    if cTargetArea = NIL
        cTargetArea = alias(select())
    endif

    /****

        If source and Target are the same, append mode
        defaults.  Otherwise, the function would be
        ineffect; copying a record onto itself.

    ****/

    if cSourceArea == cTargetArea
        l_Append = .t.
    endif


    SELECT (cSourceArea)
    nSourceRec = recno()


    SELECT (cTargetArea)
    nTargetRec = recno()


    // This will reset the TargetRec record number if necessary

    if l_Append

        SELECT (cTargetArea)

        k_NewRec(TRUE)

        nTargetRec = recno()

        if neterr()
            lRetVal = .f.
            BREAK
        endif
    endif


    /****

        In the following code, the GOTO nSourceRec/nTargetRec
        is redundant if the source record is being copied to
        a target database other than the source database.

        It is necessary only in the case that the Source
        database is the same as the Target database.  In
        this instance, the record pointer will leave the
        source record when it attempts to APPEND the
        new record onto the same database.  From that
        point on, the source record pointer and the target
        record pointer will be pointing to the same empty
        record at the bottom of the file.

    ****/


    SELECT (cSourceArea)

    for i = 1 to fcount()

        SELECT (cSourceArea)
        GOTO nSourceRec

        cSourceField = field(i)
        cSourceType  = type(cSourceField)

        xData = fieldget(fieldpos(field(i)))

        SELECT (cTargetArea)
        GOTO nTargetRec

        for j = 1 to fcount()

            cTargetField = field(j)

            if lower(alltrim(cTargetField)) == lower(alltrim(cSourceField))

                cTargetType = type(cTargetField)

                if cSourceType == cTargetType
                    fieldput(fieldpos(cTargetField),xData)
                endif

            endif

        next j

    next i

END SEQUENCE

if nOldArea != 0
    SELECT (nOldArea)
    GOTO nOldRec
endif

RETURN(lRetVal)

