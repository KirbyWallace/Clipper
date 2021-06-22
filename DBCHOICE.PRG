/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_DBChoice(cDBName, cDBIndex, cDBFdExp, cRetExpr, nTRow, nTCol, nBRow, nBCol, 
cColor, lBorder ) --> xExpression

PARAMETERS:

cDBName   = Name of Database File/Alias to Find/Open
cDBIndex  = Index[es] to Open with File
cDBFldExp = Field Expression to display
cRetExpr  = Character expression evaluated as return value


nTRow     = Window Coordinates including border
nTCol     = (i.e., actual data window is one row/col
nBRow     = inside these coordinates)
nBCol     = " "


cColor    = Color to Use for Window
lBorder   = logical, TRUE = Draw Border, False = NO BORDER (DEFAULT)
nBoxType  = Border type

SHORT:

Windowed database field picklist with return value from specified fields.

DESCRIPTION:

cDBName is either an explicit file name, or an alias of a currently 
open database file.  If not specified (NIL) then the current work area 
is assumed.  If no current work area, the function returns "" (empty()). 

All open work areas are scanned to see if the file is currently open under 
the alias specified in cDBName. If the file is open already, either in 
the current or some other open work area with the ALIAS specified in 
cDBName, k_DBChoice() switches to that area and proceeds.  If the alias is 
not found, then cDBName is used as an explicit file name to open. In 
either case, if the file is being used in, or attempting to use a file 
in, EXCLUSIVE mode, and that file cannot be accessed, then k_DBChoice() 
returns NIL to indicate such.

If the database file is NOT open in any work area, it is opened in an 
unused work area, browsed, and closed upon exit at which time, the 
original work area (if any) is restored.  Thus, k_DBChoice() will not 
change the status of your work areas or open files.  When it returns, all 
will be as it was before you made the function call. 

If the specified database IS open, then cDBName must be the ALIAS that 
the database is open under.

If the specified database is NOT open, then the filename specified must 
either the filename only with the '.dbf' assumed.  The key is that if the 
file specified in cDBName is open then cDBName is going to be used in a 
SELECT statement and must select by ALIAS.  If the file is not open then 
the file is going to be opened with the name specified in cDBName.  Thus, 
if TEST.DBF is open and cDBName = 'TEST.DBF', then the select statement 
is going to attempt: SELECT TEST.DBF which will produce a runtime 
error because the ALIAS is TEST not TEST.DBF.


It is safe, when using .DBF files to simply specify the FILENAME only.  
Thus the alias will select via a simple "SELECT cDBName", and if it is 
not open, the the "USE cDBName" will work satisfactorily. 

Thus "SELECT TEST" and "USE TEST" will both work. 

cDBIndex is an explicit index file name.  When k_DBChoice() looks for 
the database file in the open work areas, if a file is found in any of 
those work areas and k_DBChoice() switches to that area, then the 
indexes currently open in that area are used and cDBIndex is ignored. 
cDBIndex is only used when the requested database file is not open 
and k_DBChoice() itself opens it and opens the index or indexes named 
in cDBIndex with it.  This is a character expression and may contain 
multiple indexes separated by a comma in the usual way. 

cDBFldExp is a character expression containing a field name expression to 
be used to display the target database.


NOTE:

The combined length of the fields specified in cDBFldExp (not the length 
of the expression field itself) cannot exceed the window coordinates passed. 
 
cRetExpr is a character expression that is evaluated and applied at the 
time that k_DBChoice() exits the function. This evaluation is made BEFORE 
the work area is closed or exited so that the expression may reference 
any fields in the record selected.  If cRetExpr is not specified, 
_then k_DBChoice() returns the selected record's record number.


The function will automatically fill the window such that the last 
physical record will reside on the last line of the window so that there 
will be no blank records displayed. Likewise, when paging up through 
the window, if there are not enough records to fill the window, the 
first physical record will reside in the first line of the window, again 
to prevent display of blank lines in the DBChoice() window. This is 
not possible however, if the number of records in the database is less 
than the number of lines in the display window.  In such a case, blank 
lines are inevitable.  For that reason, if a blank record is 
selected, k_DBChoice() returns NIL to indicate such.

nTRow, nTCol, nBRow, nBCol are window coordinates.  By default, the 
actual working space will be one row and one character INSIDE 
these coordinates as a border is drawn AT these coordinates.  If 
these parameters are not specified, or are invalid (i.e., TOP row is 
greater than Bottom Row), default values are used.  The optional 
lBorder parameter modifies this (see below). 

The default window is 00,00 to MaxRow(),MaxCol()

cColor is a character expression containing the color string to be used 
for the k_DBChoice() window.  If you do not specifiy this parameter, 
the current colors are used as default. 

lNo_Border is a logical.  If TRUE, then no border is drawn and the 
window coordinates are used for the actual data area.  If FALSE, then the 
data area is one ROW/COL INSIDE the window coordinates and the window 
border is drawn AT the window coordinates.  Also, if .f., Column Headers 
are draw as described.


nBoxType is the type of border you wish to use.  k_DBChoice() calls 
k_PopBox() to accomplish this.  You may refer to k_PopBox() for information 
on Box Types.

k_DBChoice() presents a database for browse only, and evaluates an 
expression for a return value when ENTER is pressed.  If ESC is pressed, 
the expression is not evaluated and the function returns NIL.


RETURNS: If no Expression is specified, a record number is returned.  If 
an expression is specified and is valid, the results of that evaluation 
are returned only when ENTER is pressed.  ESC returns NIL.

EXAMPLE:



******************************************************************************/
#include "inkey.ch"

FUNCTION k_DBChoice(cDBName,  ;
                   cDBIndex, ;
                   cDBFldExp,;
                   cRetExpr, ;
                   nTRow,    ;
                   nTCol,    ;
                   nBRow,    ;
                   nBCol,    ;
                   cColor,   ;
                   lBorder,  ;
                   nBoxType)

LOCAL Old_Area  := Select()
LOCAL Old_Rec   := Recno()
LOCAL nSeek_Rec := 0
LOCAL Old_Color := SetColor()
LOCAL Old_Screen
LOCAL Ret_Val   := ''
LOCAL i
LOCAL Error := .f.
LOCAL Opened_Area := .f.
LOCAL nDataLines
LOCAL nData_Cols

LOCAL nKey
LOCAL nDBC_Opt
LOCAL nRec
LOCAL nRecsRead

MEMVAR Field_Array
MEMVAR Record_Array

PRIVATE Field_Array := { }
PRIVATE Record_Array := { }

BEGIN SEQUENCE


    // establish default values for parameter arguments not specified:

    cDBName = iif(cDBName == NIL,alias(select()),cDBName)

    if empty(cDBName)
        error = .t.
        BREAK
    endif

    cDBIndex  = iif(cDBIndex  == NIL, '', cDBIndex)
    cDBFldExp = iif(cDBFldExp == NIL, k_AllFields(cDBName,'+','k_ToChar(<!>)'), cDBFldExp)
    cRetExpr  = iif(cRetExpr  == NIL, 'RECNO()', cRetExpr)
    nTRow     = iif(nTRow     == NIL, 00, nTRow)
    nTCol     = iif(nTCol     == NIL, 00, nTCol)
    nBRow     = iif(nBRow     == NIL, MaxRow(), nBRow)
    nBCol     = iif(nBCol     == NIL, MaxCol(), nBCol)
    cColor    = iif(cColor    == NIL, SetColor(), cColor)
    lBorder   = iif(lBorder   == NIL, .f., lBorder)
    nBoxType  = iif(nBoxType  == NIL, 1, nBoxType)

    // make adjustments based upon specified options:

    if (nTRow > nBRow) .or. (nTCol > nBCol)
        // reset all coordinates to defaults
        nTrow = 0 ; nTCol = 0 ; nBrow = MaxRow() ; nBCol = MaxCol()
    endif

    if lBorder
        // if drawing a border, adjust coordinates one position
        // if you specified Bottom Row at row 0 or 1, then you're
        // just dumb and outta luck!

        nTrow += 1 ; nTCol += 1 ; nBrow -= 1 ; nBrow -= 1

    endif


    nDataLines = nBRow - nTRow+1
    nData_Cols  = nBCol - nTCol+1


    if ( select(cDBName) ) != 0 // find alias
        Select &cDBName
    else

        USE (cDBName) SHARED NEW // use file by name

        if !neterr()

            if file(cDBIndex) // if used, cDBIndex must contain a full file name
                SET INDEX TO (cDBIndex)
            endif

            GOTO TOP

            Opened_Area = .t.
        else
            Error = .t.
            Opened_Area = .f.
            BREAK
        endif

    endif

END SEQUENCE

setcolor(cColor)

Old_Screen = savescreen(nTrow-1,nTCol-1,nBRow+2,nBCol+2)

BEGIN SEQUENCE

    if error
        Ret_Val = NIL
        BREAK
    endif


    if lBorder

        k_Box(nTrow-1,nTCol-1,nBRow+1,nBCol+1,nBoxType)

    endif

    asize(Field_Array,nDataLines)
    asize(Record_Array,nDataLines)

    while .t.

        nRec = recno()

        for i = 1 to nDataLines

            Field_Array[i] = substr(&cDBFldExp+space(nData_Cols),1,nData_Cols)
            Record_Array[i] = Recno()

            SKIP

            // handle the case of:
            //
            // Data records REMAINING less than size of browse window (nDataLines)
            //

            if eof() .and. (i < nDataLines) .and. (nDataLines <= reccount())

                if empty(dbfilter())

                    GOTO BOTTOM
                    SKIP -(nDataLines-1)

                    // reset i and let it begin the loop all over again with new starting-record pointer

                    i = 0

                else
                    for i = i to nDataLines

                        // fill remaining elements with blanks and
                        // record nums to NIL - User should be checking
                        // return value for this as a flag.

                        Field_Array[i] = repl("",nData_Cols)
                        Record_Array[i] = nRec;

                    next

                    EXIT

                endif

            endif

        next

        GOTO nRec

        for i = 0 to nDataLines-1

            @ nTRow+i,nTCol PROMPT Field_Array[i+1]

        next

        Menu To nDBC_Opt ; nKey = lastkey(); RELEASE nDBC_Opt

        do case

            case nKey = K_PGUP

                for i = 1 to iif(nDataLines = 1,1,nDataLines-1)

                    SKIP -1

                    if bof()
                        GOTO TOP
                        EXIT
                    endif

                next

            case nKey = K_PGDN


                for i = 1 to iif(nDataLines = 1,1,nDataLines-1)

                    SKIP

                    if eof()

                        GOTO BOTTOM
                        SKIP -(iif(nDataLines = 1,1,nDataLines-1))
                        EXIT
                    endif

                next


            case nKey = K_ENTER

                 if Record_Array[nDBC_Opt] <= reccount()
                     GOTO Record_Array[nDBC_Opt]
                 endif

                 Ret_Val = iif(!eof(),&cRetExpr,NIL)
                 exit

            case nKey = K_ESC
                Ret_Val = NIL
                exit

        end

    end

END SEQUENCE

setcolor(Old_Color)

restscreen(nTrow-1,nTCol-1,nBRow+2,nBCol+2,Old_Screen)

if Opened_Area
    USE
endif


if Old_Area != 0
    SELECT (Old_Area)
    GOTO Old_Rec
endif

RETURN(Ret_Val)

