/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x
        Copyright (c), 1994, Wallace Information Systems Engineering            


FUNCTION:

k_Scatter(lReadOnly) --> axFieldArray

PARAMETERS:

lReadOnly : Scatter for READ ONLY  (TRUE) or
                        READ WRITE (FALSE - Default)


SHORT:

Scatter field variables to array (not memvars).  Gather with k_Gather().

DESCRIPTION:

k_Scatter() creates and returns an array with all field data from the current
record in the current work area. It differs from some scatter/gather
functions in that it does not create individual or public memory variables,
but an array containing field data and other information (some of it for use
by it's companion k_Gather() function):

Each array element contains an array of the following:

        #define READONLY  .T.
        #define READWRITE .F.

        #define SCAT_ATTR 1
        #define SCAT_NAME 2
        #define SCAT_DATA 3
        #define SCAT_SRCE 4


    array[n,SCAT_ATTR] = lReadOnly attribute  (*)
    array[n,SCAT_NAME] = Field Name
    array[n,SCAT_DATA] = Field Data
    array[n,SCAT_SRCE] = Source area alias    (*)

(*) These array elements are primarily for use by k_Gather().

Element n,SCAT_ATTR contains a true or false value indicating the
specified lReadOnly parameter.  When lReadOnly is passed as TRUE,
then TRUE is placed in these array elements.  The array element is
subsequently used by k_Gather().  k_Gather() will not replace the
corresponding database field if this element contains a TRUE,
effectively making the database READONLY from the application's
perspective.  Any changes made to these fields is discarded.

Element n,SCAT_SRCE contains the alias of the database that
the field data was derived from.  This is used as a double check,
on each field, to ensure that the correct database is current when
the function REPLACEs the fields.  If the current area is NOT what
is specified in this element, that work area is SELECTed before
the RELACE occurs.

As noted, these two elements are primarily for use by k_Gather(),
however, you CAN fiddle with them yourself if you feel the urge.

For instance, after _Scattering(), before presenting an edit
screen for editing, you may elect to reset one or more of
the fields based upon "privledge level."  The same data screen
can then be used by all without special checking of the "privledge
level" on each SAY...GET.

Also, you could, if you wanted to, directly change the SOURCE ALIAS
field manually if you wanted to, say, read from one database, but
place edits in another database.

ie:

    USE FIRST ALIAS FIRST   ; GOTO TOP

    USE SECOND ALIAS SECOND ; APPEND BLANK

    acArray = k_Scatter(READWRITE)

    for i = 1 to len(acArray)
        acArray[i,SCAT_SRCE] = 'SECOND'
    next

    k_Gather(acArray)

This would effectively duplicate the record from FIRST.DBF as a new
record on SECOND.DBF.

NOTE:

Use caution when manipulating the SCAT_ATTR and SCAT_SRCE elements.

EXAMPLE:
#define READONLY  .T.
#define READWRITE .F.

#define SCAT_ATTR 1
#define SCAT_NAME 2
#define SCAT_DATA 3
#define SCAT_SRCE 4


LOCAL axRecord := {}

USE Address ALIAS Address SHARED NEW

GOTO TOP

if rlock()

    axRecord = k_Scatter(READWRITE)

    ? axRecord[1,SCAT_ATTR] 
    * .F.       - Readonly is false, k_Gather() WILL replace this data into the database.
    * If it were .T., k_Gather() would NOT replace this field.


    ? axRecord[1,SCAT_NAME] 
    * "FNAME"   - Field Name


    ? axRecord[1,SCAT_DATA] 
    * "Kirby"   - Field contents


    ? axRecord[1,SCAT_SRCE] 
    * "ADDRESS" - alias of source database - k_Gather() uses this to ensure proper replacement of data

endif

*
* GET and edit array elements rather than individual variables
*

k_Gather(axRecord)
UNLOCK

*  all the above array elements are put back into their respective
*  database fields, and the record lock is released.


See the demo code in DEMOS\SCATGAT.

******************************************************************************/

#include "klipper.ch"

FUNCTION k_Scatter(lReadOnly)

LOCAL    axRecord := {}
LOCAL    i        := 0

BEGIN SEQUENCE

    lReadOnly = iif(lReadOnly = NIL,FALSE,lReadOnly)

    for i = 1 to fcount()


        aadd(axRecord,{NIL,NIL,NIL,NIL})
        axRecord[i,SCAT_ATTR] = lReadOnly
        axRecord[i,SCAT_NAME] = field(i)
        axRecord[i,SCAT_DATA] = fieldget(i)
        axRecord[i,SCAT_SRCE] = alias()

    next

END SEQUENCE

RETURN(axRecord)

