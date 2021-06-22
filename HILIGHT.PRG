/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Hilight( nLine, cText, cColor ) --> NI

PARAMETERS:

nLine   : Line to Highlight on
cText   : text on nLine to highlight
cColor  : color to highlight with

SHORT:

Highlight text wherever it appears on a screen or screen line.

DESCRIPTION:

_HighLight() reads the screen at the line specified in nLine and looks for 
the text passed in cText.  If found, it is rewritten on the screen in 
the color specified in cColor.

if nLine is not specified, then the function looks for and highlights the 
text wherever it occurs on the entire screen.

NOTE:



EXAMPLE:

@ 10,10 say 'Dear John,'
@ 12,10 say "I'm so sorry to have to tell you this..."

_HighLight(10,'John','w+/n')
_HighLight(,'John','w+/n')

Result: Both of these calls will do the same thing.

The first call specifies that the text is on line 10.

The second format can be used when the text has scrolled or moved, or when 
you just forgot where you put it, or when you are feeling plain lazy and 
do not want to figure which line it is on.  The text "John" will 
be highlighted wherever it occurs on the screen and as many times as 
it occurs. (Specifying the line will cause only those occurances on that 
line to be highlighted).

******************************************************************************/


FUNCTION k_Hilight(nLine, cText, cColor)
LOCAL    OldColor
LOCAL    i

if nLine = NIL
    nLine = maxrow()+1 // force full screen read
endif

OldColor = setcolor()

if nLine > maxrow()
    * whole screen
    for i = 0 to maxrow()
        __ScrRead(i,savescreen(i,00,i,MaxCol()),cText,cColor)
    next
else
    * single line only
    __ScrRead(nLine,savescreen(nLine,00,nLine,MaxCol()),cText,cColor)
endif

SetColor(oldcolor)

RETURN(NIL)

FUNCTION __ScrRead(nLine, cVar, cText, cColor)
LOCAL    i, cVarOut

i = 0
cVarOut = ''

for i = 1 to len(cVar) step 2
    cVarOut += substr(cVar,i,1)
next

if cText $ cVarOut
    setcolor(cColor)
    @ nLine,(at(cText,cVarOut)-1) say cText
endif

RETURN(NIL)

