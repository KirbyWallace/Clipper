/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Attn( cMessage, aOptions, cColor, nRowMod, nColMod, nDefault ) --> nChoice

PARAMETERS:

cMessage : Message to display
aOptions : Array of Options to choose from
cColor   : Color Scheme to use for box and text
           (Default: setcolor())
nRowMod  : Row Offset from Center (Default: 0)
nColMod  : Col Offset from Center (Default: 0)
nDefault : select element # nDefault when ESC is used to exit.
           (default: return 0 on ESC)

SHORT:

Replacement for Clipper's Alert() with additional control.

DESCRIPTION:


k_Attn() is (with a few exceptions, and a few additions) is a replacement for 
the Clipper Alert() function, allowing for several options including color 
and positioning.  The syntax of alert() is compatible, however.  The only 
syntax differences come in the expanded capabilities (ie, arguments beyond 
cMessage and aOptions).

cMessage may be omitted or specified as empty.  The result will be an box
with only the aOptions choices and no message. 

If the string contains semicolons, each line so delimited is centered
on successive lines of the box. 

aOptions is an array of strings to display as choices.  If not specified, 
a single "Ok" message is displayed (and obviously will always return 1).  
No checking is attempted to see if all options will fit across the screen.  
If you specify them, they're going up.
                                                                         
cColor is a standard Clipper Color scheme string.  If it is not 
specified, them the current color setting is used. 

nRowMod and nColMod are offsets from center.  That is, the box coordinates 
are first centered to fit the current screen mode, and then nRowMod 
and nColMod are ADDED to the TOP LEFT corner coordinates to move the 
box accordingly.  For instance, to move the box DOWN and/or to the 
RIGHT, specify a positive number. To move the box either UP or to the 
LEFT, specify negative values.

nDefault can be used to specify an option (from the array of choices) to
select if the user presses ESC to exit the message.  Alert() returns 0, as
does this function by default if not specified.  If specified, it must be
non-zero numeric.  You CAN specify 0, but what's the point? Specify negative
numbers at your own peril.


NOTE:

Differences from Alert():
-------------------------

k_Attn() will allow more than four aOption elements (Alert() ignores any
beyond the fourth).  k_Attn() will ignore NIL and empty elements (Alert()
acts strangely when NIL elements are given).

nDefault is not available in alert().


Similarities to Alert():
------------------------

If the number of lines in cMessage will not fit on the screen in the current
screen mode, the results are unpredictable.

k_Attn() saves and restores it's screen area.


EXAMPLE:

k_Attn(cMessage, aOptions, cColor, -5, -10)

this would display the box five rows UP from center, and 10 columns
LEFT from center.

k_Attn('Pick something from the list', {"This","That","The","Other","Else"}, 
'w+/b,n/w,,,gr+/g")

In this example, the row and column modifiers are not specified, so the 
k_Attn() box is centered in the display screen.

******************************************************************************/
#include "inkey.ch"

#define DISPBOXSINGLE chr(218)+chr(196)+chr(191)+chr(179)+;
                      chr(217)+chr(196)+chr(192)+chr(179)+' '

FUNCTION k_Attn(cMessage, aOptions, cColor, nRowMod, nColMod, nDefault )

LOCAL    nLines     := 1
LOCAL    nOptions   := 0
LOCAL    nBoxRows   := 0
LOCAL    nBoxCols   := 0
LOCAL    nLongest   := 0
LOCAL    nThisLen   := 0
LOCAL    nOptsLen   := 0

LOCAL    nFRow      := 0
LOCAL    nFCol      := 0
LOCAL    nTRow      := 0
LOCAL    nTCol      := 0
LOCAL    nChoice    := 0

LOCAL    cPromptStr := ""
LOCAL    cOldColor  := setcolor()
LOCAL    cScreen    := ""

LOCAL    i, j

cMessage = iif(cMessage = NIL,"",           cMessage)
aOptions = iif(aOptions = NIL,{"Ok"},       aOptions)
cColor   = iif(cColor   = NIL,setcolor(),   cColor)
nRowMod  = iif(nRowMod  = NIL,0,            nRowMod)
nColMod  = iif(nColMod  = NIL,0,            nColMod)
nDefault = iif(nDefault = NIL,0,            nDefault)

// count strings in cMessage

if ';' $ cMessage

    for i = 1 to len(cMessage)

        if substr(cMessage,i,1) = ';'
            nLongest = max(nLongest,nThisLen+4)
            nThisLen = 0
            nLines++
        else
            nThisLen++
        endif

    next

    nLongest = max(nLongest,nThisLen+4)

else
    nLongest = len(cMessage)+4
endif


// Count number of aOptions choices

for i = 1 to len(aOptions)


    if aOptions[i] != NIL

        if !empty(aOptions[i])
            nOptions++
        endif

    endif

next

// determine height and width of box

nBoxRows = nLines +3

for i = 1 to len(aOptions)

    if aOptions[i] != NIL

        if !empty(aOptions[i])

            nBoxCols += (len(aOptions[i])+2)

        endif

    endif

next

// room for two spaces at end of prompts
nBoxCols += 2

// box cols is the larger of the longest prompt string
// and the total columns of all options

nOptsLen = nBoxCols
nBoxCols = max(nBoxCols,nLongest)

setcolor(cColor)


nFRow = ( ((maxrow()/2) - (nBoxRows/2)) + nRowMod)
nFCol = ( ((maxcol()/2) - (nBoxCols/2)) + nColMod)
nTRow = nFRow+nBoxRows
nTCol = nFCol+nBoxCols-1

cScreen = savescreen(nFRow, nFCol, nTRow, nTCol)

dispbox(nFRow, nFCol, nTRow, nTCol, DISPBOXSINGLE, cColor)

for i = 1 to nLines

    cPromptStr = substr(cMessage,1,iif(';' $ cMessage,at(';',cMessage)-1,len(cMessage)))

    @ nFRow+i,((maxcol()/2)-(len(cPromptStr)/2))+nColMod SAY cPromptStr

    cMessage = substr(cMessage,iif(';' $ cMessage,at(';',cMessage)+1,len(cMessage)))

    if empty(cMessage)
        exit
    endif

next

// display aOptions

j = 0

for i = 1 to len(aOptions)

    if aOptions[i] != NIL

        if !empty(aOptions[i])

            @ nTRow-1,nFCol+2+((nBoxCols/2)-(nOptsLen/2))+j PROMPT aOptions[i]

            j += len(aOptions[i])+2

        endif

    endif

next

MENU TO nChoice

if lastkey() == K_ESC
    nChoice = nDefault
endif

restscreen(nFRow, nFCol, nTRow, nTCol,cScreen)

setcolor(cOldColor)

RETURN(nChoice)

