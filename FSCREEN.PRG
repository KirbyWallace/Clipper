/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_FScreen( cScrMsg , cKeyList , cHeader ) --> NIL

PARAMETERS:

cScrMsg  : Text for SCREEN_TITLE line MAXROWS()-2
cKeyList : Text for Key List Line MAXROWS()-1
cHeader  : Text for Screen Header Line 1

SHORT:

Display a standard KLIPPER screen.

DESCRIPTION:

k_FScreen() is a screen draw function that is used to refresh screens in a 
uniform manner.  It is designed to be used with k_Menu(), and k_KeyList(), and 
other functions which are used together to build screen i/o with a uniform 
appearance.

Each screen has three user definable areas.  The top screen header line and 
the two bottom lines.  The next to the bottom line is the screen title line 
and the bottom line is the k_KeyList() line where key help and other user 
messages are expected to appear.

NOTE:

k_FScreen() is fashioned after a popular menuing system.  It helps your 
applications fit smoothly with the Saber Menu System (TM?).  I originally 
wrote applications that were run under Saber Menu System on Novell.

The k_FScreen() function thereby made my application almost completely 
transparent.  It became almost indiscernable when the user had left the menu 
system and had entered the application (and vice versa).

Optionally, you may control the color of the screen drawn by declaring 
any/none of the following variables in your source code:

PRIVATE _FSHeadColor := 'W+/G'  // Use high white on green for cHeader Area
PRIVATE _FSTitlColor := 'W+/B'  // Use high white on blue for cScrMsg Line
PRIVATE _FSBottColor := 'W+/R'  // Use high white on red for cKeyList Line
PRIVATE _FSDeskColor := 'w+/B'  // Use high white on blue for DeskTop Area
PRIVATE _FSDeskChar  := repl('°',9) // Use ° as the desktop bckgrnd char

Note _FSDeskChar is a character scheme that is passed to the BOX command. It 
must be nine characters in length or the results will be unpredictable. 

Another desktop scheme might be chr(176) as a background, with a bordering 
box:

PRIVATE _FSDeskChar  := 'ÚÄ¿³ÙÄÀ³°'

EXAMPLE:

k_FScreen('Departmental Expense Report System - Version 1.0', ;
         'F1 - Help, ESC Exit, Use Arrow Keys, ENTER to Accept', ;
         'The XYZ Corporation of America')


******************************************************************************/

#include "klipper.ch"

FUNCTION k_FScreen( cScrMsg , cKeyList , cHeader )
LOCAL    oldcolor := SetColor()
LOCAL    acVars   := {  "LOGIN"      ,;
                        "LOGIN_ID"   ,;
                        "LOGINID"    ,;
                        "MENU_ID"    ,;
                        "MENUID"     ,;
                        "USERID"     ,;
                        "USERNAME"   ,;
                        "USER_NAME"  ,;
                        "NET_NAME"   ,;
                        "U_NAME"     ,;
                        "USER_ID"    ,;
                        "LOGIN_NAME"   }
LOCAL    cTemp := ""

MEMVAR   _FSHeadColor
MEMVAR   _FSTitlColor
MEMVAR   _FSBottColor
MEMVAR   _FSDeskColor
MEMVAR   _FSDeskChar

MEMVAR   CurUser
MEMVAR   Sys_Sec

if type('_FSHeadColor') != 'C'
    _fsHeadColor = 'b/w'
endif

if type('_FSTitlColor') != 'C'
    _fsTitlColor = 'w+/b'
endif

if type('_FSBottColor') != 'C'
    _fsBottColor = 'n/w'
endif

if type('_FSDeskColor') != 'C'
    _fsDeskColor = 'rb/b,w+/b'
endif

if type('_FSDeskChar') != 'C'
    _fsDeskChar = repl(chr(176),9)
endif

if cScrMsg = NIL
    cScrMsg = ''
endif

/*
Good scheme for Black and White

PRIVATE _FSDeskColor := 'w/n'  // k_FScreen() Colors
PRIVATE _FSHeadColor := 'w+/n'
PRIVATE _FSBottColor := 'n/w'

PRIVATE _FSNameColor := 'n/w'  // menu colors (see k_Menu(), k_MenuA())
PRIVATE _FSMenuColor := 'n/w'
PRIVATE _FSBordColor := 'n/w'
PRIVATE _FSItemColor := 'n/w,w/n'


*/


if cKeyList = NIL
    cKeyList = ''
endif

if type('curuser') = 'U'
    curuser = k_IsEnvVar( acVars, TRUE )
endif

* info box

set color to (_fsheadcolor)


@ 00,00 clear to 02,MaxCol()
@ 00,00 to 02,MaxCol()

if cHeader = NIL

    @ 02,10 say chr(193)
    @ 02,30 say chr(193)
    @ 02,40 say chr(193)
    @ 02,MaxCol()-11 say chr(193)

else
    @ 02,10 say chr(193)
    @ 02,MaxCol()-11 say chr(193) // 68

endif


* stat line

if cHeader = NIL

    @ 01,12 say curuser+' '+iif(type('sys_sec')!='U',ltrim(str(sys_sec)),'')
    @ 01,32 say str(diskspace()/1000000,4,0)+' mb'

    if len(curdir()) > 26

        cTemp = right(curdir(),23)
        cTemp = substr(cTemp,at('\',cTemp))
        cTemp = '..'+cTemp

        @ 01,42 say cTemp

    else
        @ 01,42 say curdir()
    endif

else
    k_Ctr(1,cHeader,.f.)
endif

@ 01,01 say time()
@ 01,MaxCol()-9 say date() // 70

* desktop area
set color to (_fsdeskcolor)

@ 03,00,MaxRow()-2,MaxCol() BOX _FSDeskChar

set color to (_fsTitlColor)
@ maxrow()-1,00 clear to maxrow()-1,maxcol()
@ maxrow()-1,(MaxCol()/2)-(len(cScrMsg)/2) say cScrMsg

* key list

set color to (_fsBottColor)
@ maxrow(),00 clear to maxrow(),MaxCol()
@ maxrow(),00 say cKeyList

setcolor(oldcolor)

RETURN(NIL)

