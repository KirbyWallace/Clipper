/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_FileBox( nTRow, nTCol, nBRow, cFileSpec, nBoxType, cBoxColor ) --> cFileStr

PARAMETERS:

nRow      : Top Left Corner ROW of picklist box (DEFAULT: 0)
nCol      : Top Left Corner COL of picklist box (DEFAULT: 0)
nBRow     : Bottom Row of picklist box (DEFAULT: MaxRow())
cFileSpec : file selection specification (DEFAULT: *.*)
nBoxType  : Box Border Type (DEFAULT: DOUBLETOP )
cBoxColor : Color string for box color (DEFAULT: current color)

SHORT:

Display picklist of specified files and return filename/ext.

DESCRIPTION:

k_FileBox() presents a list of files in the current directory that 
match cFileSpec.  A lightbar selection selects a file and returns the 
file name.

nTRow and nTCol define the top left corner origins of the box. nBRow 
defines the bottom row where the pick list box ends. 

The width is always 18 (12 for the file name, 2 for spacing, 2 for the 
window borders and 2 more for the box shadow - The shadow may be 
two characters wide depending upon the setting of the KBOXHIGH variable - 
See k_Box() for more information).

nBoxType is a numeric that is passed to k_Box().  See k_Box() for information 
on Box Types.

cBoxColor is the color string passed to SETCOLOR() for setting the 
display color of the box.

k_FileBox() will RETURN("") (empty string) if ESC is pressed, or if enter 
is pressed on a blank line.  Blank lines can exist when the number of 
matching files is not sufficient to fill the number of lines defined 
by ((nBRow-nTRow)-2).

NOTE:

See also: _FileList() for a similar function without the box drawing. 

_FileList() operates similarly but provides only the raw file list with no 
box or labeling.  Use it when you want to draw your own box and labels with 
the picklist inside that.

EXAMPLE:

#define BUDGET_FILES '*.BGT'

t = k_FileBox(5,5,10,BUDGET_FILES,BOXDOUBLE,'Available Budget Files')

Result: a file pick list is presented with the top corner at 5,5 and ending 
on line 10 (resulting in 4 lines for the file listing and two lines for 
the border).  When ENTER is pressed on the file, that file name is returned.

******************************************************************************/
#include "klipper.ch"

FUNCTION k_FileBox(nTRow, nTCol, nBRow, cFileSpec, nBoxType, cBoxColor)
LOCAL    cRetVal   := ''
LOCAL    acFiles   := {}
LOCAL    cScreen   := savescreen(nTRow, nTCol, nBRow+2, nTCol+44)
LOCAL    cOldColor := setcolor()
LOCAL    nSelect   := 0
LOCAL    acDir     := {}
LOCAL    i

nTRow     = iif(nTRow     = NIL, 0,                  nTRow)
nTCol     = iif(nTCol     = NIL, 0,                  nTCol)
nBRow     = iif(nBRow     = NIL, MaxRow(),           nBRow)
cFileSpec = iif(cFileSpec = NIL, '*.*',              cFileSpec)
nBoxType  = iif(nBoxType  = NIL, BOXDOUBLETOP,       nBoxType)
cBoxColor = iif(cBoxColor = NIL, setcolor(),         cBoxColor)

BEGIN SEQUENCE


acDir = directory(cFileSpec, "H") ; asize(acFiles,len(acDir))

for i = 1 to len(acDir)

    acFiles[i] = ''

    acFiles[i] += ' '+padr(alltrim(k_ToChar(acDir[i][1])),12)
    acFiles[i] += ' '+padl(alltrim(k_ToChar(acDir[i][2])),8)
    acFiles[i] += ' '+padr(alltrim(k_ToChar(acDir[i][3])),8)
    acFiles[i] += ' '+padr(alltrim(k_ToChar(acDir[i][4])),8)

next

asort(acFiles)

setcolor(cBoxColor)

k_Box(nTRow, nTCol, nBRow, nTCol+42, nBoxType, LABEL_ARROWS_RIGHT,'FileSpec: '+cFileSpec )

nSelect = achoice(nTRow+1, nTCol+1, nBRow-1, nTCol+41,acFiles)

if nSelect != 0
    cRetVal = substr(acFiles[nSelect],2,12)
endif


END SEQUENCE

setcolor(cOldColor)

restscreen(nTRow, nTCol, nBRow+2, nTCol+44, cScreen)

RETURN(cRetVal)

