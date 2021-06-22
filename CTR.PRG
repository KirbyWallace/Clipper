/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Ctr( nCtrLine, cCtrMsg, lCtrClearLine ) --> NIL

PARAMETERS:

nCtrLine : Screen Line Number
cCtrMsg  : Text to be centered
lCtrClr  : Logical indicating whether to clear line or not
           TRUE = Clear Line (default) , FALSE = No Line Clear

SHORT:

Center a string on given line, optionally clearing line first.

DESCRIPTION:

k_Ctr() Centers a string on a specified screen line.  Optionally after 
clearing the entire line.


NOTE:

See also CtrVar() which centers a string inside it's own length.

EXAMPLE:

k_Ctr(24,'THIS IS A STRING',TRUE)

Result: "THIS IS A STRING" is centered on line 24 after clearing line 24 
the third parameter is optional and defaults to TRUE.

******************************************************************************/

FUNCTION k_Ctr(nCtrLine,cCtrMsg,lCtrClearLine)

if pcount() < 3

    ********************************************************************************
    *  the only reason this should be true is that the optional var lCtrClearLine  *
    *  indicating whether or not to clear the line before centering the text       *
    *  has not been specified.  "What/where" are required.  DEFAULT IS .T.         *
    ********************************************************************************

    lCtrClearLine = .t.

endif

if pcount() >= 2 && must be at least what and where

    if lCtrClearLine
        k_Clr(nCtrLine)
    endif

    @ nCtrLine,(MaxCol()/2)-(len(cCtrMsg)/2) say cCtrMsg

endif

RETURN(NIL)

