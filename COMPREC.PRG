/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_CompRec( nSkip, cFieldName ) --> lIsSame

PARAMETERS:

nSkip     :  Number of records to SKIP (use negatives for previous records)
cFieldName:  field name to base comparison on

SHORT:

Compare field of current record with field of previous or subsequent records.

DESCRIPTION:

k_CompRec() compares a field value with the same field value of a previous
or subsequent record.  Exactly which record depends upon the value in nSkip.

If nSkip = 1, the records compared will be the current record and the next
record.  If nSkip = -1, the the comparison will be between the current and
previous records.  If nSkip = -5, then the comparison will be between the
current record and the fifth previous-to-the-current record.

You get the picture, right?

NOTE:

k_CompRec() respects and uses any open and current index.

Very little validation is done here in the interest of speed.  If you screw up
the cFieldName parameter, expect the worse!

EXAMPLE:

// if you do not know what a gazillion is, then think of the largest number
// that you can and add a bazillion to it!

USE Names ALIAS Names INDEX Names

cName = Names->LastName    // "Wallace"

for i = 1 to GAZILLION

    if ! k_CompRec( i, "LastName", Names->LastName )

        ? "The NEXT "+ltrim(str(i))+" records have the same last name..."

        EXIT

    endif

next

for i = 1 to GAZILLION

    if ! k_CompRec( -i, "LastName", Names->LastName )

        ? "The "+ltrim(str(i))+" PREVIOUS records have the same last name..."

        EXIT

    endif

next



******************************************************************************/

#include "klipper.ch"

FUNCTION k_CompRec( nSkip, cFieldName )

LOCAL    lRetVal  := FALSE
LOCAL    nOldRec  := recno()
LOCAL    cTemp    := fieldget(fieldpos(cFieldName))

SKIP ( nSkip )

if ( fieldget(fieldpos( cFieldName )) == cTemp ) .and. !eof() .and. !bof()
    lRetVal = TRUE
endif

GOTO ( nOldRec )

RETURN( lRetVal )

