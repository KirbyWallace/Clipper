/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_MenuA(nMenuTopRow, nMenuLeftCol, nMenuMaxItems, cMenuTitle, acMenuArray,
lMsgDisable, lClkDisable) --> nSelection

PARAMETERS:

nMenuTopRow   : Menu Top Left ROW
nMenuLeftCol  : Menu Top Left COLUMN
nMenuMaxItems : Maximum number of items on menu at once
cMenuTitle    : Menu Title
acMenuArray   : Array of Menu Elements
lMsgDisable   : Logical - Disable InterApp Messages (Default NO)
lClkDisable   : Logical - Disable Clock (Default NO)

(lMsgDisable and lClkDisable are reserved for future use.)

SHORT:

Genral purpose menuing facility.

DESCRIPTION:

k_MenuA() is a general purpose menuing facility.  It's operation is similar 
to k_Menu().  In k_MenuA(), however, the length of the menu can be specified 
and any extra menu items are scrolled through this "window".  k_Menu() 
simply forces the menu size to fit all elements, k_MenuA() can display 
any number of elements by scrolling the extras "achoice style."

It accepts as a parameter an array of character strings to be used as 
menu items.  It builds the menu, prompts for a selection and returns 
the number of the element selected as it's return value.  If ESC is 
pressed, it returns ZERO.

nMenuTopRow and nMenuTopLeftCol are the row/col coordinates for the top 
left corner of the menu.

nMenuMaxItems is the number of items displayable without scrolling to display 
more. It is the number of lines that will appear on the menu.  Unlike 
k_Menu(), k_MenuA() fits the menu to the window.  This means that any menu 
whose elements do not fit within the limits of the given coordinates will 
instead of spilling over, scroll within those coordinates.  For that reason 
it is possible to create "ugly" or inefficient menus by specifying a value 
for nMaxItems that is greater than the number of items in the menu array.  
(You will end up with a window larger than is necessary to hold the menu 
items and will have empty space after the last menu element.) 

lMsgDisable, if TRUE, will disable other apps/users messages being presented.

lClkDisable, if TRUE, will disable the real time clock.  The real time 
clock is specifically placed on the screen to be used with k_FScreen().  If 
you are not using k_FScreen(), you may want to disable the clock.

The most notable difference between k_Menu() and k_MenuA(), aside from 
scrollable menus, is the fact that k_MenuA() can receive station messages sent 
through the k_KMenu() menu system, whereas k_Menu() cannot.  k_MenuA() polls for 
messages upon any menu activity (i.e., when arrow keys are pressed to move 
the menu highlight bar).

APPMSG.DAT (the default name for the message file) is NOT created when 
the program polls for messages.  AppMsg must be manually created, or 
created by a call to __InitAppMsg().  The reason for this is to avoid 
overhead and unnecessary APPMSG files in apps that are not going to 
use inter-application messaging.

See k_KMenu() for information on inter-application messaging.

NOTE:

This function is the engine of k_KMenu() which manages menu configurations 
external to the program (in data files) and makes calls to k_MenuA() to 
display menus.

EXAMPLE:

LOCAL acMainMenu[5]


acMainMenu[1] = ' Menu Option One   '
acMainMenu[2] = ' Menu Option Two   '
acMainMenu[3] = ' Menu Option Three '
acMainMenu[4] = ' Menu Option Four  '
acMainMenu[5] = ' Menu Option Five  '


nMenuOpt = k_MenuA(10,10,3,'MAIN MENU','acMainMenu')


Result: A light-bar menu is displayed with the array elements 1 - 3 in 
acMainMenu[] as selectable options.  The remaining options can be seen by 
pressing the up or down arrow keys (also PgUp/ PgDn keys) to get to them.  

Once an item is selected, the number of that option is returned as it's 
return value.

The TOP LEFT corner of the menu is at ROW 10, COL 10.

******************************************************************************/

**********************************************************************************

#include "klipper.ch"
#include "achoice.ch"
#include "inkey.ch"

FUNCTION k_MenuA(nMenuTopRow, nMenuLeftCol, nMenuMaxItems, cMenuTitle, acMenuArray, lMsgDisable, lClkDisable )
LOCAL    nRetVal  := 0
LOCAL    oldcolor := SetColor()
LOCAL    i
LOCAL    Nav_Key
LOCAL    nTopR, nBotR
LOCAL    lMoreAbove, lMoreBelow

// These variables may be user-defined.  If in scope, use them instead of the default
// colors.

MEMVAR   _FSDeskColor
MEMVAR   _FSHeadColor
MEMVAR   _FSBottColor
MEMVAR   _FSNameColor
MEMVAR   _FSMenuColor
MEMVAR   _FSBordColor
MEMVAR   _FSItemColor

MEMVAR   _ClkDisable
MEMVAR   _MsgDisable
MEMVAR   _cArrayName

PRIVATE _ClkDisable := iif(lClkDisable = NIL,FALSE,lClkDisable)
PRIVATE _MsgDisable := iif(lMsgDisable = NIL,FALSE,lMsgDisable)
PRIVATE _cArrayName := acMenuArray

// if menuitems is not declared explicitly, the implicit default is the number of menu items
// to make a scrollable menu, specify less menumaxitems than there are menu items in the array
// the extraneous options will scroll within the window occupied by nMaxMenuItems.

if nMenuMaxItems = NIL
    nMenuMaxItems = len(acMenuArray)
else
    nMenuMaxItems = min( len(acMenuArray), maxrow()-(nMenuTopRow)-7 )

endif

_FSHeadColor = iif(type('_FSHeadColor') != 'C', 'b/w',      _FSHeadColor)
_FSBottColor = iif(type('_FSBottColor') != 'C', 'n/w',      _FSBottColor)
_FSDeskColor = iif(type('_FSDeskColor') != 'C', 'rb/b,w+/b',_FSDeskColor)
_FSMenuColor = iif(type('_FSMenuColor') != 'C', 'n/w,w+/n', _FSMenuColor)
_FSBordColor = iif(type('_FSBordColor') != 'C', 'n/w,w+/n', _FSBordColor)
_FSItemColor = iif(type('_FSItemColor') != 'C', 'n/w,w+/b', _FSItemColor)
_FSNameColor = iif(type('_FSNameColor') != 'C', 'b+/w',     _FSNameColor)

if !_ClkDisable
    setcolor(_FSHeadColor)
    @ 01,01 say time()
endif

setcolor(_FSBordColor)
k_Box(nMenuTopRow-1, nMenuLeftCol-1,nMenuTopRow+4+nMenuMaxItems, nMenuLeftCol+len(acMenuArray[1])+2) // +4 includes extra text lines at bottom and top of menu

setcolor(_FSNameColor)
@ nMenuTopRow,nMenuLeftCol CLEAR TO nMenuTopRow,(nMenuLeftCol+len(acMenuArray[1])-1)
@ nMenuTopRow,nMenuLeftCol+( (len(acMenuArray[1])/2)-(len(cMenuTitle)/2)+1 ) SAY cMenuTitle

setcolor(_FSMenuColor)
@ row()+1,nMenuLeftCol SAY repl(chr(196),len(acMenuArray[1])+2)

nTopR = row()+1
nBotR = nTopR+nMenuMaxItems-1

if len(acMenuArray) > nMenuMaxItems

    @ nTopR, nMenuLeftCol+len(acMenuArray[1])+2 say chr(24)
    @ nBotR, nMenuLeftCol+len(acMenuArray[1])+2 say chr(25)

endif

@ nBotR+1,nMenuLeftCol SAY repl(chr(196),len(acMenuArray[1])+2)

setcolor(_FSNameColor)
@ row()+1 , nMenuLeftCol CLEAR TO row()+1,(nMenuLeftCol+len(acMenuArray[1])-1)
@ row()   , nMenuLeftCol+1 SAY 'Enter'
@ row()   , nMenuLeftCol+len(acMenuArray[1])-12 SAY 'ESC=Previous'


setcolor(_FSBottColor)
@ MaxRow(),00 CLEAR TO MaxRow(),MaxCol()

if type('nav_key') != 'C'
    @ MaxRow(),00 SAY chr(25)+chr(24)+' - Position Bar, '+chr(17)+chr(190)+' - Execute, ESC - Exit'
else
    @ MaxRow(),00 SAY nav_key
endif

SetColor(_FSItemColor)

nRetVal = achoice(nTopR, nMenuLeftCol+1, nBotR, (nMenuLeftCol+len(acMenuArray[1])), acMenuArray,, 'k_MenuAUDF()')  // lMsgDisable,lClkDisable)' )

SetColor(oldcolor)

RETURN(nRetVal)


FUNCTION k_MenuAUDF( nMode, nElement, nPos )
LOCAL    nRetVal          := AC_CONT
LOCAL    nKeyPress        := lastkey()
LOCAL    nIdleKey         := 0
LOCAL    nOldArea         := select()
LOCAL    cOldColor        := setcolor()

LOCAL    cMessagePath     := gete("MSGPATH")
LOCAL    U_Name           := gete("U_NAME")

LOCAL    cMessageFileName := 'APPMSG.DAT'
LOCAL    cMessageNTXName  := 'APPMSG.TIF'

MEMVAR   _ClkDisable
MEMVAR   _MSGDisable
MEMVAR   _FSHeadColor  // clock uses this
MEMVAR   _cArrayName

if !empty(gete("APPMSGFILE"))
    cMessageFileName = gete("APPMSGFILE")
endif

if !empty(gete("APPMSGIDX"))
    cMessageNTXName = gete("APPMSGIDX")
endif

do case

    case nMode = AC_IDLE

        // check for messages

        if !_MsgDisable

            if !empty(u_name)

                if __UseMsg(cMessagePath,cMessageFileName,cMessageNTXName)

                    __SeekMsg()

                    if nOldArea != 0
                        SELECT (nOldArea)
                    endif

                endif

            endif

        endif

        if !_ClkDisable

            // update clock

            setcolor(_FSHeadColor)
            @ 01,01 SAY time()
            setcolor(cOldColor)

        endif

    case nMode = AC_HITTOP
        KEYBOARD chr(K_CTRL_PGDN)

    case nMode = AC_HITBOTTOM
        KEYBOARD chr(K_CTRL_PGUP)

    case nMode = AC_EXCEPT

        do case

            case nKeyPress = K_ESC
                nRetVal = AC_ABORT

            case nKeyPress = K_ENTER
                nRetVal = AC_SELECT

        otherwise
            nRetVal = k_GetGoto(_cArrayName,nKeyPress,nElement) // AC_GOTO

        endcase

endcase

RETURN(nRetVal)

FUNCTION k_GetGoto( cArrayName, nKey,nElement )
LOCAL    nRetVal := AC_CONT
LOCAL    i

// cArrayName will contain a string representing the name of the PRIVATE
// array built in k_KMenu()

// now force a jump to the first matching character item prompt
// on the unknown key that brought us here.

for i = 1 to len(cArrayName)
    if upper(substr(alltrim(cArrayName[i]),1,1)) == upper(chr(nKey))
        KEYBOARD ( iif(nElement >= i,repl(chr(K_UP),abs(i-nElement)),repl(chr(K_DOWN),abs(i-nElement))))
        EXIT
    endif
next

RETURN(nRetVal)

FUNCTION __UseMsg( cMessagePath, cMessageFileName, cMessageNTXName )
LOCAL    lRetVal := TRUE

if !empty(cMessagePath)

    if right(cMessagePath,1) != '\'
        cMessagePath = cMessagePath+'\'
    endif

endif

cMessageFileName = cMessagePath+cMessageFileName
cMessageNTXName  = cMessagePath+cMessageNTXName

if file(cMessageFileName)

    USE (cMessageFileName) NEW SHARED ALIAS __MESSAGE

    if neterr()

        lRetVal = FALSE

    else

        if !file(cMessageNTXName)

            if flock()

                INDEX ON __Message->User_Name TO (cMessageNTXName)

                UNLOCK

            else

                dbCloseArea()
                lRetVal = FALSE

            endif

        else

            if file(cMessageNTXName)
                SET INDEX TO (cMessageNTXName)
            endif

        endif

    endif

else
    // if no message file, no need to look for messages, right?
    lRetVal = FALSE

endif

RETURN(lRetVal)

FUNCTION __SeekMsg()
LOCAL    U_Name := gete("U_NAME")

if indexord() != 0

    // if the index was not available, the message system will be disabled until
    // it is available.  It would be just too slow to default to a LOCATE (which
    // could be done, but shouldn't be).

    SEEK (alltrim(U_Name))

    if found()

        while upper(alltrim(__Message->User_Name)) = upper(alltrim(U_Name))

            if __Message->Read = 'N'

                k_Ack(trim(__MESSAGE->Sender_Id)+':'+trim(__MESSAGE->Message))

                if k_RLock()
                    REPLACE __Message->Read with 'Y'
                endif

            endif

            skip

        end

    endif

endif

CLOSEAREA

RETURN(NIL)



