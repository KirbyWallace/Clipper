/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_TextBrowse(nFRow, nFCol, nTRow, nTCol, cVar, nBoxType, nBoxLabel, cLabelStr, 
cColor, lViewOnly ) --> NIL

PARAMETERS:

nFRow    : Box Top Left Row
nFCol    : Box Top Left Col
nTRow    : Box Bottom Right Row
nTCol    : Box Bottom Right Column
cVar     : Text to Browse
nBoxType : Box Line Type
nBoxLabel: Label Type to use
cLabelStr: Label String to use
cColor   : Color for Display
lViewOnly: If TRUE, displays text without pausing for panning
           or paging up or down.

SHORT:

General Purpose text browse.

DESCRIPTION:

k_TextBrowse() displays a freeform text inside the specified coorinates.

If Box Border Type is BOXNONE (no border), then the area that would have 
been the border is given to the display area, and no box shadow is drawn. 
 That is, if there is no border, the function will use the border 
line coordinates as additional display area.

See k_Box() for description of Box and Label types.

NOTE:

EXAMPLE:

cText = DATABASE->MEMFIELD

k_TextBrowse(10,10,17,40,cText,5)

Result:

The text contained in the database field MEMFIELD is fitted and displayed in 
a thick bordered box.  Up and down arrow keys, PgUp and PgDn keys move 
through the text, ESC exits.

******************************************************************************/

#include "klipper.ch"
#include "inkey.ch"

FUNCTION k_TextBrowse(nFRow, nFCol, nTRow, nTCol, cVar, nBoxType, nBoxLabel, cLabelStr, cColor, lViewOnly )
LOCAL    cOldColor := SetColor()
LOCAL    cScrn     := SaveScreen(nFRow, nFCol, nTRow+2, nTCol+2)

nBoxType  = iif(nBoxType  = NIL, 1,          nBoxType)
nBoxLabel = iif(nBoxLabel = NIL, NIL,        nBoxLabel)
cLabelStr = iif(cLabelStr = NIL, NIL,        cLabelStr)
cColor    = iif(cColor    = NIL, SetColor(), cColor)
lViewOnly = iif(lViewOnly = NIL, .F.,        lViewOnly)


SetColor(cColor)

if nBoxType != BOXNONE

    k_Box(nFRow, nFCol, nTRow, nTCol, nBoxType, nBoxLabel, cLabelStr )

endif

if lViewOnly
    KEYBOARD chr(K_ESC)
endif


if nBoxType = BOXNONE
    memoedit(cVar,nFRow, nFCol, nTRow, nTCol, FALSE)
else
    memoedit(cVar,nFRow+1, nFCol+1, nTRow-1, nTCol-1, FALSE )
endif

if !lViewOnly
    RestScreen(nFRow, nFCol, nTRow+2, nTCol+2,cScrn)
endif

SetColor(cOldColor)


RETURN(NIL)

