/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_QConfirm( cConfirm_Desc, nQRowMod, nQColMod ) --> lYesNo

PARAMETERS:

cConfirm_Desc : Question to ask
nQRowMod      : Row Modification Value    (Default 0)
nQColMod      : Column Modification Value (Default 0)

SHORT:

Asks a Y/N Question, returning TRUE or FALSE.

DESCRIPTION:

_Q_Confirm asks a "Yes or No" question supplied in cConfirm_Desc and returns 
a logical indicating the entered response.  The response box is centered 
on the screen.

The default message, if not specified, is a plain vanilla "Yes or No? 
(y/n)" message.  I suggest you specify one to avoid User-Mayhem.

nQRowMod and nQColMod are ADDED to these defaults and can be use to move 
the box off-center.  To move the box up or to the left, use negative values. 
 (ie, nGColMod = -5, would cause the box to to be first centered, but 
then moved -5 Columns to the right (Adding negative numbers effectively 
causes a move to the LEFT, or 5 columns to the LEFT).

NOTE:



EXAMPLE:

t = k_QConfirm('Is it raining outside?')

Result: t = a logical .t. / .f. depending upon user response.


k_QConfirm() can be used as an in-line assignment, making it possible to ask 
question in the middle of other function call (embedding it's return value as 
the parameter for another function) or program statements as in:

if k_QConfirm('Did lightning really strike your Aunt Mabels Big Toe?')
    @ 10,10 say "I'm so sorry..."
else
    @ 10,10 say 'My! What big tales you tell...'
endif

if DestroyEverything(k_QConfirm('Really?"))
    DESTROY EVERYTHING
endif

******************************************************************************/
#include "klipper.ch"
#include "inkey.ch"

FUNCTION k_QConfirm(cConfirm_Desc,nQRowMod,nQColMod)
LOCAL    lConfirm_Val  := FALSE
LOCAL    cCurrentColor := SetColor()
LOCAL    cQScr
LOCAL    cQ_Color

MEMVAR   GetList
PRIVATE  GetList := {} // private for sake of k_ReadF()'s access

if cConfirm_Desc = NIL
    cConfirm_Desc = 'Yes or No?'
endif

if nQRowMod = NIL
    nQRowMod = 0
endif

if nQColMod = NIL
    nQColMod = 0
endif

SAVE SCREEN TO cQScr

cConfirm_Desc = cConfirm_Desc+' (Yes/No) [ ]'

cQ_color = iif(iscolor(),'w+/r','n/w')
set color to (cQ_color)
k_Box(10+nQRowMod,(maxcol()/2)-(len(cConfirm_Desc)/2)+nQColMod,14+nQRowMod,(maxcol()/2)+(len(cConfirm_Desc)/2)+1+nQColMod)

@ 12+nQRowMod,(maxcol()/2)-(len(cConfirm_Desc)/2)+1+nQColMod to 12+nQRowMod,(maxcol()/2)+(len(cConfirm_Desc)/2)-1+nQColMod
@ 13+nQRowMod,((maxcol()/2)-(len(cConfirm_Desc)/2))+1+nQColMod say 'Y/N/ESC'


@ 11+nQRowMod,((maxcol()/2)-(len(cConfirm_Desc)/2))+1+nQColMod say cConfirm_Desc
@ 11+nQRowMod,((maxcol()/2)+(len(cConfirm_Desc)/2))-1+nQColMod GET lConfirm_Val PICTURE 'Y'

k_ReadF()

setcolor(cCurrentColor)

RESTORE SCREEN FROM cQScr

RETURN(lConfirm_Val)

