/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Menu( nMenuTopRow, nMenuLeftCol, cMenuTitle, acMenuArray ) --> nSelection

PARAMETERS:

nMenuTopRow    : Menu Top Left ROW
nMenuLeftCol   : Menu Top Left COLUMN
cMenuTitle     : Menu Title
acMenuArray    : Array of Menu Elements

SHORT:

General purpose menu facility.

DESCRIPTION:

k_Menu() is a general purpose menuing facility.  It accepts as a parameter 
an array of character strings to be used as menu items.  It builds the 
menu, prompts for a selection and returns the number of the element 
selected as it's return value.  If ESC is pressed, it returns ZERO.

NOTE:

This function is the engine of k_KMenu() which manages menu configurations 
external to the program (in data files) and makes calls to k_Menu() to display 
menus.


The function does NOT save and restore it's screen area (it makes "stacked"
menus impossible.  Therefore, you must save and restore the screen area
if desired.  Note that the screen area used is one row ABOVE and one column
to the LEFT of the coordinates passed due to a box being drawn AROUND the
area specified by the TopRow and LeftCol coordinates.  The bottom and
right coordinates depend upon how many elements are in the menu and how wide
they are - so you will have to figure that out when determining the screen
area to save.


COLORS.  The menu uses a set of default colors.  If the default colors are 
not desireable, they may be changed by defining a few PRIVATE memory 
variables that will be in scope when the menu is called:

_FSDeskColor   // desktop color
_FSHeadColor   // Top screen header color
_FSBottColor   // bottom line color
_FSNameColor   // menu name color
_FSMenuColor   // menu body color
_FSBordColor   // menu border color
_FSItemColor   // menu item color

For a fairly decent monochrome scheme, try:

PRIVATE _FSDeskColor := 'w/n'
PRIVATE _FSHeadColor := 'w+/n'
PRIVATE _FSBottColor := 'n/w'
PRIVATE _FSNameColor := 'n/w'
PRIVATE _FSMenuColor := 'n/w'
PRIVATE _FSBordColor := 'n/w'
PRIVATE _FSItemColor := 'n/w,w/n'


_FSHeadColor = 'b/w'
_FSBottColor = 'n/w'
_FSDeskColor = 'rb/b,w+/b'
_FSMenuColor = 'n/w,w+/n'
_FSBordColor = 'n/w,w+/n'
_FSItemColor = 'n/w,w+/b'
_FSNameColor = 'b/w'


EXAMPLE:

MEMVAR acMainMenu
PRIVATE acMainMenu[5]


acMainMenu[1] = 'Menu Option One '
acMainMenu[2] = 'Menu Option Two '
acMainMenu[3] = 'Menu Option Three '
acMainMenu[4] = 'Menu Option Four '
acMainMenu[5] = 'Menu Option Five '


nMenuOpt = k_Menu(10,10,'MAIN MENU','acMainMenu')

Result: A light-bar menu is displayed with the array elements in mainmenu[] 
as selectable options.  Once an item is selected, the number of that option 
is returned as it's return value.  The TOP LEFT corner of the menu is at 
ROW 10, COL 10, and the bottom right hand corner is placed according to 
the number of array elements and the length of the FIRST (not longest) 
array element.

******************************************************************************/

FUNCTION k_Menu(nMenuTopRow, nMenuLeftCol, cMenuTitle, acMenuArray )
LOCAL    nRetVal := 0
LOCAL    oldcolor := SetColor()
LOCAL    i
LOCAL    Nav_Key

MEMVAR   _FSDeskColor
MEMVAR   _FSHeadColor
MEMVAR   _FSBottColor
MEMVAR   _FSNameColor
MEMVAR   _FSMenuColor
MEMVAR   _FSBordColor
MEMVAR   _FSItemColor

/*
Good scheme for Black and White

PRIVATE _FSDeskColor := 'w/n'
PRIVATE _FSHeadColor := 'w+/n'
PRIVATE _FSBottColor := 'n/w'
PRIVATE _FSNameColor := 'n/w'
PRIVATE _FSMenuColor := 'n/w'
PRIVATE _FSBordColor := 'n/w'
PRIVATE _FSItemColor := 'n/w,w/n'

*/

if type('_FSHeadColor') != 'C'
    _FSHeadColor = 'b/w'
endif

if type('_FSBottColor') != 'C'
    _FSBottColor = 'n/w'
endif

if type('_FSDeskColor') != 'C'
    _FSDeskColor = 'rb/b,w+/b'
endif

if type('_FSMenuColor') != 'C'
    _FSMenuColor = 'n/w,w+/n'
endif

if type('_FSBordColor') != 'C'
    _FSBordColor = 'n/w,w+/n'
endif

if type('_FSItemColor') != 'C'
    _FSItemColor = 'n/w,w+/b'
endif

if type('_FSNameColor') != 'C'
    _FSNameColor = 'b/w' // b+/w
endif


        setcolor(_FSHeadColor)
        @ 01,01 say time()

        setcolor(_FSBordColor)
        k_Box(nMenuTopRow-1, nMenuLeftCol-1,nMenuTopRow+len(acMenuArray)+4, nMenuLeftCol+len(acMenuArray[1]))

        setcolor(_FSNameColor)
        @ nMenuTopRow,nMenuLeftCol CLEAR TO nMenuTopRow,(nMenuLeftCol+len(acMenuArray[1])-1)
        @ nMenuTopRow,nMenuLeftCol+( (len(acMenuArray[1])/2)-(len(cMenuTitle)/2) ) SAY cMenuTitle

        setcolor(_FSMenuColor)
        @ row()+1,nMenuLeftCol SAY repl(chr(196),len(acMenuArray[1]))

        for i = 1 to len(acMenuArray)
           @ row()+1,nMenuLeftCol PROMPT acMenuArray[i]
        next

        @ row()+1,nMenuLeftCol SAY repl(chr(196),len(acMenuArray[1]))

        setcolor(_FSNameColor)
        @ row()+1,nMenuLeftCol CLEAR TO row()+1,(nMenuLeftCol+len(acMenuArray[1])-1)
        @ row(),nMenuLeftCol SAY ' Enter  Esc=Previous'


        setcolor(_FSBottColor)
        @ MaxRow(),00 CLEAR TO MaxRow(),MaxCol()

        if type('nav_key') != 'C'
            @ MaxRow(),00 SAY 'F1 - Help, '+chr(25)+chr(24)+' - Position Bar, '+chr(17)+chr(190)+' - Execute, ESC - Exit'
        else
            @ MaxRow(),00 SAY nav_key
        endif

        SetColor(_FSItemColor)

        MENU TO nRetVal


SetColor(oldcolor)

RETURN(nRetVal)

