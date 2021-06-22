/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Ticker(nLine,nCol,nLength,cText,nDelay,lPause,cSepChar) --> NIL

PARAMETERS:

nLine   : Line on which to display
nCol    : Column at which to begin display
nLength : Length of display
cText   : Text to display
nDelay  : Delay between characters
lPause  : Pause when Display Complete?
cSepChar: Separator Character

SHORT:

A Times-Square'esque ticker tape display.

DESCRIPTION:

k_Ticker() presents a "ticker-tape" type display of one line of text.  The 
text can be any length, but typically should be longer than the display 
width (it wouldn't look like a ticker-tape display if all the text could 
fit in the display line at once!).

The nLine and nCol define the line and left-most column of the line that 
will be used as the display area.  The nLength parameter determines how 
many characters wide the display will be.

Because some CPU's are much faster than others, fast CPU's may display the 
text so quickly that it cannot be read.  The nDelay parameter can be used to 
set a pause time between each of the characters in the text string.  This 
number's value will depend upon the type CPU being used.  Experiment to find 
a suitable value (typically starting at 300 - 400).

If lPause is TRUE, then the display pauses and waits for a keystroke before 
beginning the display over again.  If it is FALSE, the display runs non stop, 
from left to right.  (My apologies to my Chinese users :-)

cSepChar can be used to change the default separator character (a SPACE).  
You can change it to dots, for instance by passing '.' in this parameter.

NOTE:



EXAMPLE:

k_Box(5,10,7,75) // set up a box for the display

String = 'This is an example of the function syntax for the '+ ; 
         'Function k_Ticker().  It scolls from left to right '+ ;
         'and fits within the box we just drew.'

k_Ticker(6,11,63,String,200,'.')

Result: The text string displays on line 6 between positions 11 and 74, with 
a 200 count pause between each character and using a dot as the separator 
character.

******************************************************************************/
#define LEAD_CHARS  repl(iif(cSepChar = NIL,' ',cSepChar),nLength)
#define TRAIL_CHARS repl(iif(cSepChar = NIL,' ',cSepChar),len(cText))

FUNCTION k_Ticker(nLine,nCol,nLength,cText,nDelay,lPause,cSepChar)
LOCAL    i, j, k
LOCAL    cString := LEAD_CHARS+cText+iif(len(cText) < nLength,TRAIL_CHARS,' ')

LOCAL    cDispString := ''

nDelay = iif(nDelay = NIL,1,nDelay)
nDelay = iif(nDelay < 1,1,nDelay)

BEGIN SEQUENCE

while .t.

    for i = 1 to len(cString)

        cDispString = substr(cString,i)

        @ nLine,nCol say substr(cDispString,1,nLength)

        // for interchar display delay purposes and to break in mid-message
        for j = 1 to nDelay

            if (k := inkey()) != 0
                BREAK
            endif

        next

    next

end

END SEQUENCE

if lPause
    inkey(0)
endif

RETURN(NIL)

