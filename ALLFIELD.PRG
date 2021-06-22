/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_AllFields(cFileName,cSepChar,cFieldFunc) --> cFieldNameString

PARAMETERS:

cFileName  : Name of database file to extract field names from
cSepChar   : Delimiter character (Optional : ',' default)
cFieldFunc : Field Function (Optional : Default = none)

SHORT:

Create a string expression containing all database field names.

DESCRIPTION:

k_AllFields() returns a string of all field names in the database 
specified delimited with the character passed in cSepChar. 

If cSepChar is not specified, the default delimiter is "," (comma).

cFieldFunc is a function to apply to each field name.  If not specified, 
no function is applied.  The Field Name MUST be represented by <!> in order 
to allow multiple function nesting around the field name.  If there 
were always to be a single function applied, you could simply specify the 
name of the function and k_AllFields() could supply the necessary "()".  
But since, in the case of "LTRIM(STR())", k_AllFields() will need to know 
that the field name should be placed inside the first ")", not the last.

See example.

NOTE:

LTRIM(STR(<!>)) is different from SUBSTR(<!>,1,5) in placement of the 
field name.

See examples.

If the specified database is open in any work area, k_AllFields() switches 
to that area, uses the file, creates the string and restores the 
original current work area when done.

If the specified database is not open in any area, then the string 
in cFileName is used as an explicit file name to open the database.

EXAMPLE:

Assume TEST.DBF is open in one of the open work areas.  k_AllFields() will use 
the alias to SELECT the proper work area:

t = k_AllFields('TEST')

Result: t = 'FIELD1,FIELD2,FIELD3'

Assume TEST.DBF is NOT open in ANY work area.  In this case, you must supply 
the DATABASE FILE NAME to be USED:

t = k_AllFields('TEST.DBF','+')

Result: t = 'FIELD1+FIELD2+FIELD3'


// These two example specify a FIELD FUNCTION:

t = k_AllFields("TEST.DBF",'+',"TRIM(<!>)")

Result: t = "TRIM(FIELD1)+TRIM(FIELD2)+TRIM(FIELD3)"

t = k_AllFields("TEST.DBF",'+',"LTRIM(STR(<!>,0))")

Result: t = "LTRIM(STR(FIELD1,0))+LTRIM(STR(FIELD2,0))..." etc.

******************************************************************************/
#include "klipper.ch"

FUNCTION k_AllFields(cFileName,cSepChar,cFieldFunc)
LOCAL    Opened_area := .f.
LOCAL    nOldArea := Select()
LOCAL    nOldRec  := Recno()
LOCAL    cRetVal := ''
LOCAL    lError  := .f.
LOCAL    i

cSepChar = iif(cSepChar = NIL,',',cSepChar)

if cFieldFunc != NIL
    if type(cFieldFunc) == 'C'
        if at('<!>',cFieldFunc) = 0
            cFieldFunc = NIL
        endif
    endif
endif


BEGIN SEQUENCE

    if at('.',cFileName) = 0
        // no file ext specified, might be alias reference

        if ( select(cFileName) ) != 0 // find alias

            // alias reference

            Select &cFileName

        else

            // not alias reference, must be file name with '.dbf' assumed

            Select 0

            USE (cFileName) SHARED  // use file by name

            if !neterr()

                Opened_Area = .t.
            else
                lError = .t.
                Opened_Area = .f.
                BREAK
            endif

        endif
    else

        // specific file name with extention specified

        Select 0
        USE (cFileName) SHARED  // use file by name

        if !neterr()

            Opened_Area = .t.
        else
            lError = .t.
            Opened_Area = .f.
            BREAK
        endif

    endif

END SEQUENCE

BEGIN SEQUENCE

    if lError

        cRetVal = ''
        BREAK

    endif


    for i = 1 to fcount()
        if cFieldFunc = NIL
            cRetVal += fieldname(i)+cSepChar
        else
            cRetVal += stuff(cFieldFunc,at('<!>',cFieldFunc),3,fieldname(i))+cSepChar
        endif
    next

    cRetVal = substr(cRetVal,1,len(cRetVal)-1)

END SEQUENCE

if Opened_Area
    CLOSEAREA
endif

if nOldArea != 0
    Select (nOldArea)
endif

if nOldRec != 0
    GOTO nOldRec
endif

RETURN(cRetVal)

