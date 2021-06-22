/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_KMenu(__level,__prefuncarg,__postfuncarg,__scrnarea) --> NIL

PARAMETERS:

__Level       : Menu Level to display
__PreFuncArg  : Name of Pre-menu Function (string)
__PostFuncArg : Name of Post-menu Function (string)
__ScrnArea    : string containing coords of screen area to save

SHORT:

A data driven general purpose menuing subsystem.

DESCRIPTION:

OVERVIEW

The menu system is completely self contained, data driven, and can be used 
with little or no modification to your programming style.  In short, the Menu 
Sub-System completely takes over the responsibility of screen management and 
menu navigation and passes control to functions that are specified in the 
menu definition file.  When menu options are selected by the user, the 
function coresponding to that menu item is called. The programmer need only 
ensure that these functions are indeed present in the executable, however, it 
is not necessary.  Any function specified in the menu definition file that is 
not present in the run-time environment is simply ignored.  This allows the 
programmer to completely prototype an entire system's menu structure at once, 
and then develop the supporting functions later.

Menu Definition Files

To initially create the menu definition file, simply call the k_KMenu() 
function either with or without arguments.  The k_KMenu() function itself 
checks to see if the menu definition file exists, in the location specified 
(if specified) or in the current directory (if not specified).  If the file 
does not exist, an empty menu definition file is created accordingly.

This will result in an UNDEFINED MENU LEVEL error message which can be 
ignored.  The menu definition file is now available for modification.  Use 
dBASE, the Clipper DBU utility, or KEDIT to fill in the table with the 
desired menu information.

The default name of the menu definition file is MENUDEF.DAT, however, this 
may be changed by any application that uses the menu system by specifiying 
the name to use in a variable called _KMENUNAME.  The menu defintion file 
uses an index, the Table Information File (".TIF") to order itself.  The 
default name for this file is MENUDEF.TIF, and may also be changed by the 
application by including the name in a variable called _KMENUIDX. 
Location of the Menu Definition Files 

The location of the menu definition file and it's index need not be the 
current directory (the directory in which the program is being run).  The 
default location of the menu definition file, and index file, is the current 
working directory (application directory), unless otherwise specified by 
including a PATH in the _KMENUNAME and _KMENUIDX variables.

Example 1: To use the default menu definition file and index names in the 
current working directory, do nothing.  The defaults will apply: 

FUNCTION MAIN()

k_KMenu(0)

RETURN(NIL)

In this example, the menu definition file will be named MENUDEF,DAT, the 
index file will be MENUDEF.TIF, and both will be in the current working 
directory.

Example 2: To use a different name and location for each of the files:

FUNCTION MAIN()

MEMVAR _KMENUNAME
MEMVAR _KMENUIDX

PUBLIC _KMENUNAME := '\SYSTEM\BUDGET.MNU'
PUBLIC _KMENUIDX  := '\SYSTEM\BUDGET.IDX'

k_KMenu(0)

RETURN(NIL)

In this example, the application and all of it's data files may be kept and 
run in one directory, while the menu definition file and index can be renamed 
to BUDGET.MNU and BUDGET.IDX, respectively, and located in a directory called 
"\SYSTEM".  For advanced applications being run in a Novell Network 
environment, the users of the application can have login scripts which 
establish a READ ONLY attribute to the \SYSTEM directory.  
MAP M:=FS1/VOL1:\SYSTEM\ 

The application programmer can then refer to the menu definition file 
location as:

PUBLIC _KMENUNAME := "M:BUDGET.MNU"
PUBLIC _KMENUIDX  := "M:BUDGET.IDX"

This offers two advantages.  First, it ensures that no user can inadvertently 
or intentionally alter the menu definition files, and secondly, it allows the 
programmer to employ the network operating system itself as a security 
measure: allowing only users who have properly mapped drive specifications to 
access the program.

Menu Definition and Execution Procedure

Menus are created in LEVELS.  Each menu is comprised of a group of items that 
have a common LEVEL.  Typically, LEVEL 0 or LEVEL 1 is the MAIN MENU and 
calls all other menu levels and supporting functions.  One menu level may 
call another menu level resulting in a multiple layered menu scheme.  To call 
another menu level, k_KMenu() simply makes a recursive call to itself:

k_KMenu(6)

This would load menu level 6 over the current menu.  Menu level 6 may have 
several items that call functions, or may have items that make other calls to 
other menu levels.  Menu Level 1 may have an option which calls Menu Level 6 
which may in turn have a menu item that calls Menu Level 12 and so on.  No 
extra programming is required to accomplish this as each menu saves the state 
of the menu system before calling another menu level, and restores that state 
when the called menu is exited.

TECHNICAL DETAILS

Calling Convention and Parameter Options

The behavior of the Menu Sub-System can be modified in part by the 
developer's application.  There are a number of variables that the system 
looks for that can contain information that alters the way the program 
performs.

Parameters:

The function call to k_KMenu() can include four parameters, one of which is 
mandatory, the other three optional.  The actual function syntax is:

k_KMenu( nLevel, cPreFunc, cPostFunc, cScrArea )

nLevel: (REQUIRED)  This parameter defines which menu is to be presented.

cPreFunc:  This function is very similar to the PRE_FUNC for menu items.  The 
difference is that this function is called just BEFORE each MENU, instead of 
before each menu item.  If this parameter is specified, it is evaluated to 
determine if it is a valid function call (i.e., is defined in the source code 
and is in scope), and if it is, it is called.  The return value from this 
function is always ignored.  After the function is executed, the menu is 
displayed and the user is able to make menu selections. 

cPostFunc:  This function works identically to the cPreFunc function, but it 
is evaluated and (if applicable) called AFTER the user has made a menu 
selection, and BEFORE the menu calls the MENU_FUNC function.

Variables:

The operational characteristics of the menu can also be modified by use of 
certain variables which, if present and in scope at runtime, control certain 
features. 

_kMenuName: By default, the name of the menu definition file is MENUDEF.DAT.  
The application that uses the Menu Sub-System can change this to any other 
file name by specifying it in a PUBLIC or PRIVATE character variable:

_KmenuName := 'DATAMENU.DBF'

The Menu Sub-System will then look for a file called "DATAMENU.DBF' from 
which to build menus.  If the variable is not declared or not in scope when 
the k_KMenu() function is called, or if it is, but is not a character type, 
the default menu file name of MENUDEF.DAT is used.

_kMenuIdx:  The Menu Sub-System menu Table Information File (TIF) contains 
information that logically orders the menu definition file.  The default name 
for this file is MENUDEF.TIF.  It can be changed in the same manner as menu 
definition file, but specifying the file name in a PUBLIC or PRIVATE 
character variable: 

_KMenuIdx := 'DATAMENU.TIF'

_kMenuLockKey:  The default key for the keyboard lock is ALT-F10.  This key 
can be reassigned to any valid key combination by specifying it's INKEY() 
value in a PUBLIC or PRIVATE numeric variable:

_KMenuLockKey := K_CTRL_F5

In this example, be sure to include:

#include "INKEY.CH"

_kGlobalFunc: A function can be defined that is called once before each menu 
is built and displayed.  This function is called BEFORE the menu is drawn, 
and BEFORE a menu selection is made.  It differs from the PRE_FUNC function 
(discussed later) in that the PRE_FUNC function is called after the menu 
selection has been made and before the MENU_FUNC function is executed, while 
the GLOBAL FUNCTION is called only once at the beginning of each menu.  To 
define this global function, you need only define a PUBLIC or PRIVATE 
character variable that will be in scope when the menu system is initialized, 
that contains the name of the function to call: 

_kGlobalFunc := 'function_name()'

FILE STRUCTURE

This is the structure of the data file that drives the menu system:

    LEVEL,      C,  3
    ORDER,      C,  2
    MENU_TEXT,  C, 75
    MENU_FUNC,  C, 75
    PRE_FUNC,   C, 75
    POST_FUNC,  C, 75
    MENU_HELP,  C, 40
    FUNC_DESC,  M
    INT_MENU,   L
    SECURITY,   N,  1


The first three fields, LEVEL, ORDER, and MENU_TEXT work together and need to 
be discussed first.

LEVEL: A complete menu is a group of items.  All items that pertain to a 
particular menu are grouped together by their Menu Level.  Menu levels need 
not be contiguous, you can have levels 1, 3, 5, 9, or 1, 2, 3, 4.  Any 
missing Levels are simply ignored.  The Menu Level does nothing but group 
menu items together.  This will be emphasized and made clear later when 
discussing, Menu_Func.

ORDER: Inside each Level, the menu options are ordered by their menu option 
order.  The menu option order that is placed in this field is concatenated 
with the text in the menu text field, and all together they comprise the 
complete menu.  NOTE:  ALL menus must have ONE item, ORDER=0, which denotes 
that the text contained in MENU_TEXT is to be used as the menu header, and is 
not itself a menu item.

MENU_TEXT: The Menu Text is the text that is displayed as a menu option in 
each menu item.

Summary of LEVEL-ORDER-MENU_TEXT

Each menu is comprised of a group of menu items that have the same menu 
level.  Inside each menu level, the items are ordered according to their menu 
order.  The menu order (logical order, not the ORDER field) is added as a 
string to the menu text to comprise a menu item and the whole group becomes a 
complete menu.

For example, the following MENUDEF.DAT entries:

    ORDER = 1,  LEVEL = 0, MENU_TEXT = "MAIN MENU"
    ORDER = 1,  LEVEL = 1, MENU_TEXT = "Menu Option One"
    ORDER = 1,  LEVEL = 2, MENU_TEXT = "Menu Option Two"
    ORDER = 1,  LEVEL = 3, MENU_TEXT = "Menu Option Three"

will produce the following menu:

    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    ³        MAIN MENU          ³°
    ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´°
    ³  1 - Menu Option One      ³°
    ³  2 - Menu Option Two      ³°
    ³  3 - Menu Option Three    ³°
    ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´°
    ³ Enter      Esc = Previous ³°
    ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ°
      °°°°°°°°°°°°°°°°°°°°°°°°°°°°


The length of the longest MENU_TEXT field (as opposed to the length of the 
menu header) determines the width of the menu.  In this case, "Menu Option 
Three" is the longest and the entire menu was dimensioned to accommodate it.  
The complete menu is drawn, including the constant and predefined keys of 
Enter to select a menu item and ESC to exit the menu. Also drawn is the 
shadow alongside the menu, giving an appearance of depth.  The shadow in this 
example is just a graphic character, however, in your application, it will be 
whatever text or graphics lay below the menu in the shadowed area.  The 
shadow is always drawn in low- white on black giving the impression of a true 
shadow.  

The menu sub-system takes care of screen management while it is running.  It 
saves the screen inside which the menu will reside BEFORE it is drawn.  When 
the menu is exited by pressing ESC, the original screen that laid under the 
menu is redisplayed.

The next three fields, MENU_FUNC, PRE_FUNC, and POST_FUNC work together to 
call the functions that are defined for each menu item.  They are discussed 
next.

MENU_FUNC:  This field contains the name of the function that is to be called 
when this menu item is picked.  It should be specified with the parenthesis 
and any necessary arguments:

Option_One()
Option_Two(cUser_Name)
Option_Three('James Powell')

The menu system can be completely developed before any of the supporting 
functions are written.  At runtime, if the requested function is undefined or 
unspecified, nothing happens when you execute that menu item.  In the above 
function call examples, if Option_Two() is undefined at runtime, then nothing 
will happen when that menu item is executed.  If Option_Three() is defined, 
then Option_Three() is executed, receives 'James Powell' as a parameter and 
proceeds.  When the function is complete and returns, control returns to the 
menu system which redraws the menu and waits for another selection. 

PRE_FUNC: This is a function call exactly like the MENU_FUNC function call.  
If specified, it is checked and called in a similar manner to MENU_FUNC.  If 
not specified, then like MENU_FUNC, nothing is called.


The purpose of this function is to allow you to call another function 
immediately before calling the function in MENU_FUNC. This allows you to do 
things like check statuses, security levels, or do anything else that you 
want before actually performing the MENU_FUNC function.  For Example, if 
PRE_FUNC = 'PreCallFunc()', and MENU_TEXT = 'MenuOptionFunc()', then when you 
execute this menu item, a call is made to PreCallFunc(), which executes and 
returns and THEN MenuOptionFunc() is called.

The PRE_FUNC function's return value is significant.  Not only does the 
PRE_FUNC function allow you to take care of preliminary details before 
calling the MENU_FUNC function, it's return value can control whether or not 
the MENU_FUNC function is even executed.  The PRE_FUNC function can return 
any value at all, but the only value that is significant is a logical value. 
If the PRE_FUNC function returns FALSE, the MENU_FUNC function is NOT 
executed  if TRUE the MENU_FUNC function IS executed.  Any other type return 
value is ignored.

POST_FUNC:  The POST_FUNC field is similar to the PRE_FUNC and MENU_FUNC in 
that it also contains a function call that is to be executed immediately 
AFTER the MENU_FUNC function call.  If it is not specified, or if specified 
but the requested function is undefined in the source code, then no call is 
made.  The return value from the POST_FUNC, if any, is ignored.

The remaining fields, MENU_HELP, FUNC_DESC, INT_MENU, and SECURITY provide 
various functionality which is discussed next. 

MENU_HELP: Data entered in this field is used as a "hook" into the On-Line 
Help Sub-System.  The Menu Sub-System and the On-Line Help Sub-System are 
designed to cooperate with each other.  A brief note is in order though.  The 
On-Line Help Sub- System uses the contents of a variable in your source code 
called "Help_Label" to derive the help text from the help database.  You use 
the On-Line Help by leaving a "trail of Help_Labels" in your source code.  
The Help_Label variable from whichever procedure is active when the user 
presses F1 is used as the help key.

But when the Menu Sub-System is active, and the user's screen is displaying a 
menu, none of your source code is active! This is because the menu system 
takes care of all screen activity related to the front end menu system and 
only branches into your source code when a menu item is executed that calls 
one of your MENU_FUNC functions.  For that reason, you have no opportunity to 
specify the HELP_LABEL that should be used while the menu is active.

You can use the MENU_HELP field to add text to be used for the Help_Label 
variable.  The Menu Sub-System takes this field's contents and declares a 
LOCAL HELP_LABEL that contains your MENU_HELP text.  Thus, you can continue 
to use the On-Line Help sub-system to provide context sensitive help even for 
the menus.

FUNC_DESC:  This field is a memo field and does not affect the Menu 
Sub-System in any way.  It is an area for you to record free-form text notes 
about the menu item, and a description of the function that it calls.  It is 
used largely for documentation purposes.

INT_MENU: Creating multiple-level menus is as simple as making your MENU_FUNC 
function make a recursive call to the Menu Sub-System itself.  For example, 
if you started your program with "k_KMenu(1)", thus kicking off the menu 
system, you can easily make a menu item which has a MENU_FUNC function that 
calls "k_KMenu(2)".  By doing this, menu level 2 is loaded on top of menu 
level 1, and you then have a multiple-level stacked menu!

The Menu Sub-System recognizes when a menu item is defined to make a 
recursive call to itself, and adds a caveat "?" to the right side of the menu 
item to indicate to the user that this menu item leads to another menu.

As you define your menus, you will eventually have to branch out into your 
own source code in order to accomplish anything useful.  Often, your 
MENU_FUNC call may branch to another menu that you have specifically encoded 
into your source code.  This might be any sort of menu with any appearance.  
But, if you branch from a menu in the Menu Sub-System to a menu in your 
source code, the Menu Sub-System has no way of knowing what is coming next in 
your source, so it cannot automatically add the menu indicator caveat to the 
menu item.  You must tell it that another menu of your own design follows.  
You may want to add the right-hand side caveat to indicate that another menu 
follows. This Logical field adds that caveat if TRUE.

SECURITY: The Menu Sub-System, when running, looks for a numeric variable 
called SYS_SEC in scope in the environment.  If you define a numeric variable 
called SYS_SEC in your program BEFORE making your first call to the Menu 
Sub-System, the Menu Sub-System will use this variable as a security level 
that determines whether menu items appear on a particular menu or not. 

For instance, if your variable SYS_SEC=5, and SECURITY=9, then the user does 
not have sufficient access to even have this item on their menu, and it will 
not appear there.  Any menu items skipped for lack of security will not 
affect the numbering of the menu items.  One user may have menu options 1 
through 5, and another user who does not have access to menu option 3 will 
have menu options 1 - 4, with the unavailable menu option not being 
displayed.

Example:  If user RONW has a SYS_SEC of 9, and user BENC has a SYS_SEC of 5 
and they both run the following menu:

    ORDER  LEVEL  TEXT                   SECURITY
    ----------------------------------------------
    1      0    EDIT DATA MENU           0
    1      1    EDIT FINANCIAL DATA      0
    1      2    DELETE FINANCIAL DATA    6
    1      3    REPORT FINANCIAL DATA    0
    1      4    IMPORT FINANCIAL DATA    0

here are the two menus that they will see:

             USER: RONW                          USER: BENC
    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿     ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    ³      EDIT DATA MENU       ³°    ³      EDIT DATA MENU       ³°
    ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´°    ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´°
    ³ 1 - EDIT FINANCIAL DATA   ³°    ³ 1 - EDIT FINANCIAL DATA   ³°
    ³ 2 - DELETE FINANCIAL DATA ³°    ³ 2 - REPORT FINANCIAL DATA ³°
    ³ 3 - REPORT FINANCIAL DATA ³°    ³ 3 - IMPORT FINANCIAL DATA ³°
    ³ 4 - IMPORT FINANCIAL DATA ³°    ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´°
    ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´°    ³ Enter      Esc = Previous ³°
    ³ Enter      Esc = Previous ³°    ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ°
    ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ°     °°°°°°°°°°°°°°°°°°°°°°°°°°°°°
     °°°°°°°°°°°°°°°°°°°°°°°°°°°°°

User BENC does not have the "Delete" option on his menu because the SECURITY 
field demands a security level greater than or equal to 6 and his SYS_SEC is 
5.  Notice that BENC's menu renumbered itself to account for the missing menu 
item.  Again, it is the logical order, not the ORDER field that determines 
the number of the menu option.

Keyboard Lock: 

The Menu Sub-System contains a keyboard locking mechanism that allows the 
user to lock up the program under password protection while leaving the 
system running, but unattended.  At any point, the user may press ALT-F10, 
enter a password, and press ENTER.  The screen will be cleared, a message 
indicating that the system is locked, and a prompt for an unlocking password 
is presented.  The only way to unlock the program is to enter the same 
password again, at which point the application resumes where it left off.


The ALT-F10 is a default key and can be changed by your program.  See the 
following section on Conventions, Parameters and Options for details.

Since the Menu Sub-System makes all calls to other functions, this keyboard 
password can be set anywhere, even when the execution has branched from the 
menu to your source code.

Navigation Key List

While a menu is being displayed, the very last line of the screen contains 
navigation and selection key help.

This key help can be changed to suit your preferences by declaring a PUBLIC 
or PRIVATE character variable named NAV_KEY that will be in scope when you 
initiate the menu system:

PUBLIC Nav_Key := 'Make your selection and press ENTER'

Summary of Available Menu Function Calls

Since much program flow-control is taken over by the Menu Sub-System, 
flexibility has been built in to give the developer several opportunities to 
"intervene" during the period when the Menu Sub-System has control.  The 
following is a summary of "points" where your application can step in for a 
moment to take care of things:

1) At the beginning of every menu display. Using: _KGlobalFunc Function Call.

2) Before the selected menu option is called. Using: PRE_FUNC Function Call.

3) After the selected menu option is called. Using: POST_FUNC Function Call.

Each is called in the following order:

1  - _KGlobalFunc function is called if defined.

2  - Menu is drawn and user is prompted to select.

3  - User selects and executes a Menu Option

4a - If PRE_FUNC function is defined and returns TRUE:
     4a 1: The MENU_FUNC function is called if defined.
     4a 2: GOTO Step 5

4b - If PRE_FUNC is defined and returns FALSE:
     4b 1: The MENU_FUNC is NOT called, even if defined.
     4b 2: GOTO Step 5

4c - If PRE_FUNC is NOT defined:
     4c 1: The MENU_FUNC function is called if defined.
     4c 2: GOTO Step 5

5  - The POST_FUNC function is called if defined.

6  - The menu is redrawn and the process restarts at Step 1.

NOTE:

The _prefuncarg and _postfuncarg are independent of the pre_func and 
post_func FIELD functions that are called upon execution of menu 
items. _prefuncarg, and _postfuncarg are performed once upon each call to 
the k_KMenu() function whereas pre_func and post_func are defined and 
called for each menu option as they are selected.

In like manner as _prefuncarg, _kglobalfunc, if declared and in scope, 
is evaluated and executed if present and is performed BEFORE _prefuncarg. 
 That makes for two pre-menu functions and one post menu function that can 
be called independantly of the declared field functions (pre_func 
and post_func).

The pre_func field function will be performed just before the menu 
option function. The Post_func will be performed just after the menu 
option function.  In the case that the menu option function is a 
recursive call to _kmenu, the effect is that pre_func occurs immediatly 
prior to displaying the menu, and post_func occurs immediatly after the 
menu is displayed. This allows you to take care of necessities in 
between menus.

Optional: A KeyBoard Password may be set at any menu by pressing ALT-F10 
and entering the password UNLESS that key has been redefined by 
your application.  In this case, the key can be changed by 
setting "_KMENULOCKKEY" to contain the key that is used to set the 
keyboard lock.  

Example: 

_KMENULOCKKEY = K_ALT_F5 // would set Alt-F5 to Lock Keyboard

Note: Only F2...F10, Ctrl-F2...F10, and ALT-F2...F10 can be used to 
redefine the Keyboard lock key if the default key of ALT-F10 is not used. 

Reserved File Names: menudef.dat, menudef.idx, _update.dbf, _temp.dbf

Also, Menu Levels 999 and 9999 are reserved for internal use.


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



******************************************************************************/
#include "klipper.ch"
#include "inkey.ch"

#define KM_MAIN  999
#define KM_EXIT  9999

FUNCTION k_KMenu( __level,  __prefuncarg,  __postfuncarg,  __scrnarea, __NonInterrupt )
#include "kfile.ch"


LOCAL    _nul, _nul2, _menu_items, _scr_save
LOCAL    _order_0_found, _menu_name, _call_level, _screen, oldarea, oldcolor
LOCAL    _prefunc_nul, _postfunc_nul, _global_nul
LOCAL    _pfvalidate

STATIC   __CallLevel := 0

FIELD LEVEL
FIELD ORDER
FIELD MENU_TEXT
FIELD MENU_FUNC
FIELD PRE_FUNC
FIELD POST_FUNC
FIELD MENU_HELP
FIELD FUNC_DESC
FIELD INT_MENU
FIELD SECURITY
FIELD FLAG

MEMVAR   _menu_options
MEMVAR   _menu_function
MEMVAR   _pre_function
MEMVAR   _post_function
MEMVAR   i, j, k
MEMVAR   Help_Label

MEMVAR  GetList

MEMVAR  KEY_LIST
MEMVAR  LEVEL_0_REC
MEMVAR  OLD_AREA
MEMVAR  SCR_MSG
MEMVAR  SYS_SEC
MEMVAR  _KGLOBALFUNC
MEMVAR  _KMENUIDX
MEMVAR  _KMENULOCKKEY
MEMVAR  _MSGKEY
MEMVAR  _KMENUNAME
MEMVAR  _KMENUNOTE
MEMVAR  _KSCRCOORD
MEMVAR  _LONGEST
MEMVAR  _MENU_COL
MEMVAR  _MENU_DEPTH
MEMVAR  _MENU_ROW
MEMVAR  _MENU_SECURITY

MEMVAR  _level, _prefuncarg, _postfuncarg, _scrnarea // param list
PRIVATE _level, _prefuncarg, _postfuncarg, _scrnarea // param list
PRIVATE Help_Label


// increment current menu call level
__CallLevel++


// assign the formal parameters to privates that will be
// in scope during recursive calls to k_KMenu()

_level       := __level
_prefuncarg  := __prefuncarg
_postfuncarg := __postfuncarg
_scrnarea    := __scrnarea

// Default menu type to k_MenuA() unless specifically requested k_Menu()
__NonInterrupt := iif(__NonInterrupt = NIL, FALSE, __NonInterrupt)

oldarea = select()
oldcolor = setcolor()

************************************************************************************
* set the GLOBAL Menu Name/Index variables if they exist in the PUBLIC environmnet *
************************************************************************************
* i.e. PUBLIC _kmenuname = 'demendef.dat'                                          *
*      PUBLIC _kmenuidx  = 'demendef.idx'                                          *
* existence of this global screen coordinate will override the default             *
* menu file name of "menudef.dat".  This is handy if you will have more than one   *
* application with their own menus in the same directory.                          *
************************************************************************************

if type('_kmenuname') == 'U'    && _kmenuname is undeclared
    PUBLIC _kmenuname
    _kmenuname = 'menudef.dat'
endif

if type('_kmenunote') == 'U'    && _kmenunote (DBT) is undeclared
    PUBLIC _kmenunote
    _kmenunote = 'menudef.dbt'
endif

if type('_kmenuidx') == 'U'    && _kmenuidx is undeclared
    PUBLIC _kmenuidx
    _kmenuidx = 'menudef.tif'
endif

if type('_disablelock') == 'U'

    if type('_kmenulockkey') == 'U'                           // _kmenulockkey is undeclared
        PUBLIC _kmenulockkey := K_ALT_F10
    else
        // F1 - ALWAYS reserved for Help and cannot be used as keyboard lock key

        if type('_kmenulockkey') == 'N'                       // it is defined, and...
            if !k_InRange(_kmenulockkey,1,26)                 // not Ctrl-A...Z
                if !k_InRange(_kmenulockkey,-2,-9)            // not F2...F10
                    if !k_InRange(_kmenulockkey,-20,-29)      // not Ctrl-F2...F10
                        if !k_InRange(_kmenulockkey,-30,-39)  // not Alt-F2...F10
                            PUBLIC _kmenulockkey := K_ALT_F10 // Set Default to Alt-F10
                        endif
                    endif
                endif
            endif
        endif
    endif
endif

if type('_MsgKey') == 'U'    && _MsgKey is undeclared
    PUBLIC _MsgKey := K_ALT_F9
else
    // F1 - ALWAYS reserved for Help and cannot be used as the message key

    if type('_MsgKey') == 'N'
        if !k_InRange(_MsgKey,1,26)                 // not Ctrl-A...Z
            if !k_InRange(_MsgKey,-2,-9)            // not F2...F10
                if !k_InRange(_MsgKey,-20,-29)      // not Ctrl-F2...F10
                    if !k_InRange(_MsgKey,-30,-39)  // not Alt-F2...F10
                        PUBLIC _MsgKey := K_ALT_F9  // Set Default to Alt-F9
                    endif
                endif
            endif
        endif
    endif
endif

SET KEY _kmenulockkey TO k_LockKey()
//SET KEY _MsgKey       TO __SendMessage() coming soon!!!

*******************************************************************************
* Get Security Level (if set)
*******************************************************************************

if type('SYS_SEC') != 'N'
    PRIVATE SYS_SEC := 0
endif

*******************************************************************************
* check if an update file structure request has been sent in the _level param *
*******************************************************************************

begin sequence


    // check for return to main
    if __level = KM_MAIN
        KEYBOARD repl(chr(27),__CallLevel-2)
        BREAK
    endif

    // check for return to DOS
    if __level = KM_EXIT
        KEYBOARD repl(chr(27),__CallLevel-1)
        BREAK
    endif

    if !file('&_kmenuname')
        __Create_KM()
    endif

    if type('_level') == 'C'

        do case

            case lower(_level) == 'u'

                // NEEDS WORK !!!!!!!!!!!!!!!!!!!!!!!!!!!

                * update file structure

                if file(_kmenuname)
                    **********
                    * update *
                    **********

                    if file('_update.dbf')
                        erase _update.dbf
                    endif

                    if file('_update.dbt')
                        erase _update.dbt
                    endif

                    rename &_kmenuname to _update.dbf
                    rename &_kmenunote to _update.dbt


                    Old_Area = Select()
                    select 0

                    __create_km()

                    k_XUse(_kmenuname)

                    append from _update.dbf

                    erase _update.dbf
                    erase _update.dbt

                    use

                    __BuildMenuIdx(_kmenuname,_kmenuidx)

                    //use &_kmenuname
                    //erase &_kmenuidx
                    //index on level+order to &_kmenuidx

                    use

                    if Old_area != 0
                        Select (Old_area)
                    endif



                else
                    **********
                    * create *
                    **********

                    __create_km()

                endif

        endcase

        break

    endif


    *********************************************************************************
    * process the GLOBAL Screen Save coords if they exist in the PUBLIC environmnet *
    *********************************************************************************
    * i.e. declare PUBLIC _kscrcoord and _kscrcoord = '0,0,22,79'
    * existence of this global screen coordinate will override the passed
    * coordinates in the argument list
    **********************************************************************

    if substr(type('_kscrcoord'),1,1) == 'C'    && _kscrcoord is declared
        if !empty(_kscrcoord)                   && and is not empty
            if k_ChCount(',',_kscrcoord) == 3   && and right number of elements defined
                _scrnarea = _kscrcoord
            endif
        endif
    endif

    ****************************************************************************

    *********************************************************************************
    * process the GLOBAL Function if it exists in the PUBLIC environmnet            *
    *********************************************************************************
    * i.e. if you define _kglobalfunc at the top of your main routine,  you will
    * not need a PUBLIC declaration.  If, however, you wish a GLOBAL function to be
    * executed at some menu level below the first, or if you wish to begin using
    * the global function at some point other than immediatly, then declare PUBLIC
    * _kglobalfunc, and _kglobalfunc = 'UPDATE_SCR()', when you wish the global
    * function to begin taking effect, and write a function called  UPDATE_SCR(),
    * linking it in with your application.  REMEMBER to release  the public
    * declaration when you wish to terminate use of the Global function
    *********************************************************************************

    _global_nul = ''
    if substr(type('_kglobalfunc'),1,1) != 'U'     && _kglobalfunc is declared
        if !empty(_kglobalfunc)                    && and is not empty
            if type(_kglobalfunc) == 'UI'          && and contains a valid function call
                _global_nul = &_kglobalfunc
            endif
        endif
    endif

    ****************************************************************************

    ****************************************************************************
    * process the Pre-Call Function if passed as the optional second parameter *
    ****************************************************************************

    _prefunc_nul = ''

    if substr(type('_prefuncarg'),1,1) != 'U'    && parameter is present
        if !empty(_prefuncarg)                   && and is not empty
            if type(_prefuncarg) == 'UI'         && and contains valid function call
                _prefunc_nul = &_prefuncarg
            endif
        endif
    endif

    ****************************************************************************


    * set our entry levels and menu coordinates on the first menu

    if type('_level') == 'U'
        _level = 1
    endif

    if type('_menu_depth') == 'U'
        _menu_depth = 1
    else
        _menu_depth = _menu_depth+1
    endif

    if type('_menu_row') == 'U'
        _menu_row = 3
    endif

    if type('_menu_col') == 'U'
        _menu_col = 0
    endif

    ************************************************************************************
    * build menu control index if missing - if file becomes corrupt, delete to rebuild *
    ************************************************************************************

    __BuildMenuIdx(_kmenuname, _kmenuidx)


    ********************************
    * calc screen save coordinates *
    ********************************

    _scr_save = 'screen'+ltrim(str(_level))
    &_scr_save = savescreen(0,0,MaxRow(),MaxCol())

    do while .t.

        __CheckMenuIdx(_kmenuname,_kmenuidx)

        Help_Label = ''  // reset before each menu "prepends" it's specifics

        restscreen(0,0,MaxRow(),MaxCol(),&_scr_save)

        select 99
        k_SUse(_kmenuname,'menudef')
        set index to &_kmenuidx

        seek alltrim(str(_level))

        if !found()
            k_Ack('Internal Error: Undefined Menu Level '+ltrim(str(_level)) )
            clear all
            close all
            set color to
            set cursor on
            quit

        else
            Level_0_Rec = Recno()
        endif

        _menu_items = 0
        _longest = 0

        _order_0_found = .f.

        while alltrim(level) == alltrim(str(_level))

            if alltrim(order) = '0'

                _order_0_found = .t.
                _menu_name = alltrim(menu_text)

                _Menu_Security = Security

                // hook into SYS_HELP->Help().  specific first, kmenu general last
                // 1) Add help for the currently displayed menu
                // 2) Add help for each current menu item
                // 3) Add KMENU general Help to End

                // get the menu help key for the entire menu - this is extracted from the
                // menu level 0 record.

                if !empty(Menu_Help)
                    Help_Label = alltrim(Menu_help) // 1) add current MENU level help
                endif

            else

                if Sys_Sec >= Security

                    _menu_items++
                    _longest = max(_longest,len(alltrim(menu_text))+1)

                endif

            endif

            skip

        end

        if !_order_0_found
            k_Ack('Internal Error: Menu Order 0 Not Found for Level '+ltrim(str(_level)) )
            clear all
            close all
            set color to
            set cursor on
            quit
        endif

        /*

          k_MenuA() uses achoice rather than "menu to" to accomplish it's task.
          Unlike "Menu To", achoice will not ignore a leading space when
          attempting AC_GOTO, thus, it would not, by itself, select an item
          by pressing the item number.  k_MenuA() then must trim off this
          leading space.  Sad, but true.  I like the leading space for
          ergonomics and esthetic design.

          k_Menu() uses "Menu To: and does not need this mod.

        */

        declare _menu_options[_menu_items]
        declare _menu_function[_menu_items]
        declare _pre_function[_menu_items]
        declare _post_function[_menu_items]

        GOTO Level_0_Rec

        i = 1

        while alltrim(level) == alltrim(str(_level))

            if alltrim(order) != '0'

                if Sys_Sec >= Security

                    if __NonInterrupt
                        _menu_options[i] = ' '+iif(_menu_items < 10,ltrim(str(i)),substr(ltrim(str(i))+'  ',1,2))+;
                                           ' - '+substr(menu_text,1,_longest)+;
                                           iif((lower(substr(menu_func,1,6)) = '_kmenu'.or. int_menu),chr(16),' ')
                    else
                        _menu_options[i] = iif(_menu_items < 10,ltrim(str(i)),substr(ltrim(str(i))+'  ',1,2))+ ;
                                           ' - '+substr(menu_text,1,_longest)+;
                                           iif((lower(substr(menu_func,1,6)) = '_kmenu'.or. int_menu),chr(16),' ')
                    endif

                    _menu_function[i] = iif(!empty(menu_func), k_SubUntil(alltrim(menu_func),,'//') , 'k_Nothing()')
                    _pre_function[i]  = iif(!empty(pre_func),  k_SubUntil(alltrim(pre_func),,'//')  , 'k_Nothing()')
                    _post_function[i] = iif(!empty(post_func), k_SubUntil(alltrim(post_func),,'//') , 'k_Nothing()')


                    if !empty(Menu_Help)
                        Help_Label += iif(empty(Help_Label),'','+')+alltrim(Menu_Help) // 2) add menu ITEM help
                    endif

                    i++

                endif

            endif

            skip

        end

        if !empty(Help_Label)
            Help_Label += '+KMENU' // 3) add the kmenu system help
        else
            Help_Label = 'KMENU'
        endif


        dbCloseArea() // close menu definition file

        select (oldarea)

        if __NonInterrupt

            // use noninterruptible k_Menu()

            _call_level = k_Menu(_menu_row+_menu_depth*2, ;
                                _menu_col+_menu_depth*5, ;
                                _menu_name, ;
                                _menu_options)
        else

            // use interruptible k_MenuA()

            // the default nMenuMaxElements will be 4 short of the number of screen lines remaining.
            // if all options will fit, use number of menu options as nMenuMaxItems.  Else, use number that will
            // fit on remaining lines of screen.  This is handled in the min() expression.

            // This min() usage ensures that no part of the menu will fall onto the bottom two lines
            // (the screen id line and the keylist line when using k_FScreen()).  The lower shadow of the
            // menu will stop on maxrow()-2 [ie, line 22 in 25x80 mode]

            _call_level = k_MenuA(_menu_row+_menu_depth*2, ;
                                 _menu_col+_menu_depth*5, ;
                                 min(  ( maxrow()-(_menu_row+_menu_depth*2)-7 ), _Menu_Items  ), ;
                                 _menu_name, ;
                                 _menu_options )

        endif


        if (lastkey() != 27) .and. (_call_level != 0)

            BEGIN SEQUENCE

            *******************************************
            * execute the pre_function if any  and    *
            * receive the return value in _pfvalidate *
            *******************************************

            _nul = _pre_function[_call_level]

            if type(_nul) == 'UI'  && pre_func is defined
                _pfvalidate = &_nul
            endif

            ****************************************************************
            * execute the menu_function - If PREFUNC returned a logical in *
            * _pfvalidate, execute menu selection if _pfvalidate = .t.     *
            ****************************************************************

            if valtype(_pfvalidate) = 'L'

                if !_pfvalidate
                    BREAK
                else
                    _nul = _menu_function[_call_level]

                    if type(_nul) == 'UI'  && menu_func is defined
                        _nul2 = &_nul
                    endif

                endif

            else

                _nul = _menu_function[_call_level]

                if type(_nul) == 'UI'  && menu_func is defined
                    _nul2 = &_nul
                endif

            endif

            ****************************************************************
            * In similar fashion, use the Menu Function's return value to  *
            * determine whether to call the post_func function, if any.    *
            ****************************************************************

            if valtype(_nul2) = 'L'


                if !_nul2
                    BREAK
                else
                    _nul = _post_function[_call_level]

                    if type(_nul) == 'UI'  && post_func is defined
                        _nul2 = &_nul
                    endif
                endif

            else

                _nul = _post_function[_call_level]

                if type(_nul) == 'UI'  && post_func is defined
                    _nul2 = &_nul
                endif

            endif

            END SEQUENCE

        else

            _menu_row = _menu_row-2
            _menu_col = _menu_col-5

            exit

        endif

    enddo

    ******************************************************************************************
    * process the Post-Call Function if passed as the optional third parameter before return *
    ******************************************************************************************

    _postfunc_nul = ''
    if substr(type('_postfuncarg'),1,1) != 'U'   && parameter is present
        if !empty(_postfuncarg)                  && and is not empty
            if type(_postfuncarg) == 'UI'        && and contains valid function call
                _postfunc_nul = &_postfuncarg
            endif
        endif
    endif

    ****************************************************************************

end sequence

select (oldarea)
setcolor(oldcolor)

__CallLevel--

RETURN(NIL)

*!*********************************************************************
*!
*!       Function: k_Nothing()
*!
*!*********************************************************************
FUNCTION k_Nothing()
RETURN('')

*!*********************************************************************
*!
*!       Function: __CREATE_KM()
*!
*!      Called by: k_KMenu()       (function  in KMENU.PRG)
*!
*!           Uses: _TEMP.DBF
*!               : MENUDEF.DAT
*!
*!        Indexes: MENUDEF.IDX
*!
*!*********************************************************************
FUNCTION __Create_KM(lAsk)
#include "kfile.ch"
#include "klipper.ch"
LOCAL   OldArea
LOCAL   lCreate

lAsk = iif(lAsk = NIL,.f.,lAsk)

if lAsk
    lCreate = k_QConfirm('Missing Menu Definition File - Create and Continue?')
else
    lCreate = .t.
endif

if lCreate

    FILE_BEGIN &_kmenuname

        FLD LEVEL,      C,  3
        FLD ORDER,      C,  2
        FLD MENU_TEXT,  C, 45
        FLD MENU_FUNC,  C, 75
        FLD PRE_FUNC,   C, 75
        FLD POST_FUNC,  C, 75
        FLD MENU_HELP,  C, 40
        FLD FUNC_DESC,  M
        FLD INT_MENU,   L
        FLD SECURITY,   N,  1
        FLD FLAG,       C,  1

    FILE_END &_kmenuname


endif

select (oldarea)

RETURN(NIL)

*!*********************************************************************
*!
*!       Function: k_KMInit()
*!
*!          Calls: k_KMenu()       (function  in KMENU.PRG)
*!
*!*********************************************************************
FUNCTION k_KMInit()
k_KMenu('u')

RETURN(NIL)

*!*********************************************************************
*!
*!       Function: __BuildMenuIdx()
*!
*!*********************************************************************
FUNCTION __BuildMenuIdx(cMenuName, cMenuIdx)

LOCAL    nOldArea := select()

FIELD level, order

if !file(cMenuIdx)


        if select(cMenuName) = 0

            while TRUE

                USE (cMenuName) NEW SHARED

                if !neterr()
                    exit
                endif

            end

            GOTO TOP
            INDEX ON level+order TO (cMenuIdx)

            dbclosearea()

        else

            select (cMenuName)

            INDEX ON level+order to (cMenuIdx)

        endif


endif

SELECT (nOldArea)

RETURN(file(cMenuIdx))

*!*********************************************************************
*!
*!       Function: __CheckMenuIdx()
*!
*!*********************************************************************

FUNCTION __CheckMenuIdx(cMenuname,cMenuIdx)

if !file(cMenuIdx)
    __BuildMenuIdx(cMenuName, cMenuIdx)
endif

RETURN(NIL)


*!*********************************************************************
*!
*!       Function: __ForceMenuIdx()
*!
*!*********************************************************************

FUNCTION __ForceMenuIdx(cMenuname, cMenuIdx)

LOCAL    cLine := savescreen(maxrow(),0,maxrow(),maxcol())

k_KeyList('Updating Menu Control Index...','w+*/r') ; inkey(2)

k_FDelete(cMenuIdx)

__BuildMenuIdx(cMenuName, cMenuIdx)

restscreen(maxrow(),0,maxrow(),maxcol(),cLine)

RETURN(NIL)

