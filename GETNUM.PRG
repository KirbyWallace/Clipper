/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_GetNum( cGetStr, cNumPic, nGRowMod, nGColMod ) --> nInteger

PARAMETERS:

cGetStr     : Character Prompt
cNumPic     : Picture Statement to use
nGRowMod    : Row modification (added to default of 12)
nGColMod    : Column modification

SHORT:

Prompt for and accept a numeric value.

DESCRIPTION:

k_GetNum() prompts for a number (passed as parameter) and returns the answer 
as a numeric.

k_GetNum() is capable of accepting keyboard input without issueing a GET/READ. 
It can therefore be called while already in a READ without disrupting that 
READ.


nGRowMod and nGColMod are ADDED to these defaults and can be use to move the 
box off-center.  To move the box up or to the left, use negative values.  
(I.e., nGColMod = -5, would cause the box to to be first centered, but then 
moved -5 Columns to the right (Adding negative numbers effectively causes a 
move to the LEFT, or 5 columns to the LEFT).

If the picture statement in cNumPic is longer then the prompt in cGetStr, 
that length becomes the maximum length of the number that will be accepted.

cNumPic is NOT optional.  It controls the number of siginificant digits in 
the number to be entered.  If it is not specified, the default is a 10 
digit integer.  The decimals allowed are derived from the picture clause 
as well.  If it is not specified, a default picture of '9999999999' is 
used (allowing only up to a ten digit integer). 

999.99 will allow a number with three integer digits and two decimal digits.

9,999.99 will allow four integer places and two decimal places

.999 will allow NO integer places and three decimal places

Picture clauses must contain "9"'s to denote digits.  Just like 
Clipper itself.  The picture clause itself will be used exactly as a 
regular picture clause in Clipper.  The difference is, the number of 
9's denote how many int/dec digits are allowed.

Box colors are white on red.

NOTE:

See also: k_GetStr() which accepts string input.

EXAMPLE:

EXAMPLE:  t = k_GetNum('Enter Maximum Number','9999999999')

In this example, the maximum number of keystrokes that will be accepted is 
10.  No decimals will be allowed. 

t = k_GetNum('Enter Maximum Number','99.999')
Result: three decimals will be allowed

t = k_GetNum('Enter Maximum Number','99.9999')
Result: four decimals allowed

******************************************************************************/

FUNCTION k_GetNum(cGetStr,cNumPic,nGRowMod,nGColMod)
LOCAL    nResponse
LOCAL    cCurrentColor
LOCAL    nBoxWidth
LOCAL    cQScr
LOCAL    cGColor
LOCAL    cConfirmDesc
LOCAL    i

MEMVAR   GetList

PRIVATE  GetList := {}

cGetStr   = iif(cGetStr   = NIL, 'Enter Number:', cGetStr   )
cNumPic   = iif(cNumPic   = NIL, '9999999999',    cNumPic   )
nGRowMod  = iif(nGRowMod  = NIL, 0,               nGRowMod  )
nGColMod  = iif(nGColMod  = NIL, 0,               nGColMod  )

nBoxWidth = max(len(cNumPic),len(cGetStr))

if at('.',cNumPic) != 0

    nResponse = val( repl('0',k_ChCount('9',substr(cNumPic,1,at('.',cNumPic))))+'.'+;
                     repl('0',k_ChCount('9',substr(cNumPic,at('.',cNumPic)))) )
else
    nResponse = 0
endif

cCurrentColor = setcolor()

save screen to cQScr

cGColor = iif(iscolor(),'w+/r','n/w')
set color to (cGColor)
k_Box(10+nGRowMod,40-(nBoxWidth/2)+nGColMod,14+nGRowMod,40+(nBoxWidth/2)+1+nGColMod)

@ 12+nGRowMod,40-(nBoxWidth/2)+1+nGColMod to 12+nGRowMod,40+(nBoxWidth/2)+nGColMod

@ 11+nGRowMod,(40-(nBoxWidth/2))+1+nGColMod SAY cGetStr
@ 13+nGRowMod,(40-(nBoxWidth/2))+1+nGColMod GET nResponse PICTURE (cNumPic)

k_ReadF()

setcolor(cCurrentColor)

restore screen from cQScr

RETURN(nResponse)

