/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Password(nRow,nCol,cPrompt,nStrLen,nMinLen,cColor,lUpper,lShow) --> cString

PARAMETERS:

nRow      : Row & Col Coordinates at which the password border box
nCol      : is drawn.
cPrompt   : Prompt for Password
nStrLen   : Maximum / cutoff length for password
nMinLen   : Minimum Length of Password
cColor    : Color string to use for password (must be a visible color)
lUpper    : Logical - Forces password to upper case if .T.
lShow     : Logical - echo actual password instead of default "******"

SHORT:

Provides a coloured, boxed, prompted, hidden or masked password entry field

DESCRIPTION:

k_Password() draws a box whose top-left corner is at nRow, nCol. Inside
this box a prompt is displayed and below that a password is accepted 
and returned as the functions return value.

NOTE:



EXAMPLE:

Pass1 = k_Password(5,10,'Enter Password',10,5,'b+/w')

A password is accepted that must be at least 5 characters in length but 
less than 10 characters.  The password box will be drawn in w+/b.

Pass1 = k_Password(5,10,'Enter Password',10,5,'b+/w',TRUE,TRUE)

Same thing as last example, but this time the password will be forced to 
UPPER CASE and will be shown as it is typed.

******************************************************************************/

#include "klipper.ch"
#include "inkey.ch"

FUNCTION k_Password(nRow,nCol,cPrompt,nStrLen,nMinLen,cColor,lUpper,lShow)
LOCAL cPassStr := ''
LOCAL cOldColor := setcolor()
LOCAL BoxWidth, cScreen

nStrLen  = iif( nStrLen = NIL, len(cPrompt), nStrLen )
nMinLen  = iif( nMinLen = NIL, 0,            nMinLen )
cColor   = iif( cColor  = NIL, setcolor(),   cColor )
lUpper   = iif( lUpper  = NIL, FALSE,        lUpper )
lShow    = iif( lShow   = NIL, FALSE,        lShow )

BoxWidth = max(len(cPrompt),nStrLen)+2

cOldColor = setcolor()
cScreen = savescreen(nRow,nCol,nRow+5,nCol+BoxWidth+2)

SET COLOR TO (cColor)

k_Box(nRow,nCol,nRow+4,nCol+BoxWidth)

@ nRow+1,nCol+1 say cPrompt

@ nRow+2,nCol+1 say repl('Ä',BoxWidth-1)
@ nRow+3,nCol+1 say repl(' ',BoxWidth-1)
@ nRow+3,nCol+1 say ''

cPassStr = k_EchoPass(nRow+3,nCol+1,nStrLen,nMinLen,lUpper,lShow)

setcolor(cOldColor)

restscreen(nRow,nCol,nRow+5,nCol+BoxWidth+2,cScreen)

RETURN(cPassStr)



FUNCTION k_EchoPass(nRow,nCol,nStrLen,nMinLen,lUpper,lShow)

LOCAL    cPassStr := ''
LOCAL    nCursor  := set(_SET_CURSOR)
LOCAL    nOldRow, nOldCol
LOCAL    i

SET CURSOR ON

nRow    = iif( nRow    = NIL, row(), nRow )
nCol    = iif( nCol    = NIL, col(), nCol )
nStrLen = iif( nStrLen = NIL, 10,    nStrLen )
lUpper  = iif( lUpper  = NIL, FALSE, lUpper )
lShow   = iif( lShow   = NIL, FALSE, lShow )
nMinLen = iif( nMinLen = NIL, 0,     nMinLen )

@ nRow,nCol say space(nStrLen) ; DevPos(nRow,nCol)

while TRUE

    i := inkey(0)

    if i == 13
        if ( len(cPassStr) < nMinLen )
            tone(2000,2)
            nOldRow = row() ; nOldCol = col()
            k_KeyList('Password must be at least '+ltrim(str(nMinLen))+' Characters - Try Again')
            DevPos(nOldRow,nOldCol)
            loop
        else
            exit
        endif
    endif

    if i == K_BS
        cPassStr = substr(cPassStr,1,len(cPassStr)-1)
    else
        if lUpper
            if k_InRange(asc(chr(i)),65,90)
                cPassStr += chr(i)
            else
                if k_InRange(asc(chr(i)),97,122)
                    cPassStr += chr(i-32)
                else

                    tone(2000,1)

                    nOldRow = row() ; nOldCol = col()
                    k_KeyList('PASSWORD MUST BE UPPERCASE A-Z ONLY')
                    DevPos(nOldRow,nOldCol)

                endif
            endif
        else
            cPassStr += chr(i)
        endif
    endif

    @ nRow,nCol say space(nStrLen)                                 // first clear old pword
    @ nRow,nCol say iif(lShow,cPassStr,repl('*',len(cPassStr)))    // redisplay new pword

    if ( len(cPassStr) = nStrLen )
        exit
    endif

end

set(_SET_CURSOR,nCursor)

RETURN(cPassStr)

