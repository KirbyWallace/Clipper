/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_GetStr(cGetStr, nStrWidth, lMatchWidth, cPicture, nGRowMod, nGColMod, 
lUpper) --> cString

PARAMETERS:

cGetStr     : Character Prompt | Initial Value
nStrWidth   : Maximum string length accepted
lMatchWidth : Match nStrWidth to Length of cGetStr
cPicture    : Picture string
nGRowMod    : Row modification (added to default of 12)
nGColMod    : Column modification
lUpper      : Logical - force input to upper case if TRUE.

SHORT:

Prompt for and accept user character string input.

DESCRIPTION:

k_GetStr() asks a question (passed as parameter) and returns the answer as 
a trimmed string.

cGetStr is the Prompt String.  If it contains a "|" (verticle bar) 
anywhere, the remainder of the string following the "|" becomes the 
initial value of the string.

k_GetStr("Enter Your Name:",40)

In this example, there is no initial value.  The name must be typed, 
or nothing (blank) will be returned.

k_GetStr("Enter Your Name:|Kirby",40)

In this example, the name will initially be "Kirby" and can be accepted 
by pressing enter.

k_GetStr() is capable of accepting keyboard input without issueing a GET/READ. 
It can therefore be called while already in a read without disrupting that 
READ.

The entire prompt is centered in a box on the screen.  The default rows 
are 12-16.  The columns vary depending upon the length of cGetStr, which 
is centered on the screen.

nGRowMod and nGColMod are ADDED to these defaults and can be use to move 
the box off-center.  To move the box up or to the left, use negative values. 
 (I.e., nGColMod = -5, would cause the box to to be first centered, but 
then moved -5 Columns to the right (Adding negative numbers effectively 
causes a move to the LEFT, or 5 columns to the LEFT).

cPicture is a picture string to be used on the GET.

nStrWidth and lMatchWidth are mutually exclusive. If you pass nStrWidth the 
response string will be that length.  If you pass lMatchWidth == .t. then 
nStrWidth becomes ineffect, and the response string will match the length of 
the prompt string. 

This is useful for ergonomics, but should not be used if you need to control 
the length of the response string (as when you are prompting for a file name 
where you need no more than eight characters.  

In this case, pass nStrWidth == 8, and do not pass lMatchWidth, or pass it as 
FALSE

Box colors are white on red.

NOTE:

See also: k_GetNum() which reads numerics, and possibly k_Password() 
which receives a masked password.

EXAMPLE:

t = k_GetStr('Enter Label of Hard Disk to Format',40)
Result: t = 'WISE_DEV'

In this example, the maximum number of keystrokes that will be accepted is 
40.

t = k_GetStr('Enter Label of Hard Disk to Format',,TRUE)

In this example, the maximum number of keys that would be accepted is the 
width of the prompt string, i.e., 34.

cName = 'Kirby'
t = GetStr("Enter Your Name:|"+cName)

In this case, the prompt will be "Enter Your Name:", and the intial value 
will be "Kirby" (derived from cName). Note that in this case, there is no 
string width specified. The string field will be the length of the prompt  
which happens to be 16 + 5 = 21 spaces.

******************************************************************************/
#include "klipper.ch"

FUNCTION k_GetStr(cGetStr,nStrWidth,lMatchWidth, cPicture ,nGRowMod,nGColMod,lUpper)
LOCAL    cTemp          := ""
LOCAL    Response       := ""
LOCAL    Current_Color  := ""
LOCAL    BoxWidth
LOCAL    QScr
LOCAL    G_Color
LOCAL    Confirm_Desc
MEMVAR   GetList
PRIVATE  GetList := {} // needs be private so that k_ReadF() can get to it

if cGetStr == NIL
    Confirm_Desc = 'What?'
endif

if "|" $ cGetStr
    Response = substr(cGetStr,at("|",cGetStr)+1)
    cGetStr = substr(cGetStr,1,at("|",cGetStr)-1)
endif

if nStrWidth == NIL
    nStrWidth = 40
endif

if lMatchWidth == NIL
    lMatchWidth = .F.
endif

if nGRowMod == NIL
    nGRowMod = 0
endif

if nGColMod == NIL
    nGColMod = 0
endif

if lUpper = NIL
    lUpper = FALSE
endif

if cPicture = NIL
    if lUpper
        cPicture = "@K!"
    else
        cPicture = "@K"
    endif
endif

BoxWidth = max(len(cGetStr),nStrWidth)

if lMatchWidth
    //Response = space(BoxWidth)
    Response = alltrim(response)+space(BoxWidth-len(alltrim(response)))
else
    //Response = space(nStrWidth)
    Response = alltrim(response)+space(nStrWidth-len(alltrim(response)))
endif

Current_Color = setcolor()

save screen to QScr

G_Color = iif(iscolor(),'w+/r','n/w')
set color to (G_Color)
k_Box(10+nGRowMod,40-(BoxWidth/2)+nGColMod,14+nGRowMod,40+(BoxWidth/2)+1+nGColMod)

@ 12+nGRowMod,40-(BoxWidth/2)+1+nGColMod to 12+nGRowMod,40+(BoxWidth/2)+nGColMod

@ 11+nGRowMod,(40-(BoxWidth/2))+1+nGColMod say cGetStr

@ 13+nGRowMod,(40-(BoxWidth/2))+1+nGColMod get Response PICTURE (cPicture)


k_ReadF()

setcolor(Current_Color)

restore screen from QScr

RETURN(alltrim(Response))

