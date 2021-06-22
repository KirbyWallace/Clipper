/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_InitWin(Win_Name, Win_TR, Win_TC, Win_BR, Win_BC, Win_Color,Win_Up) --> NIL

PARAMETERS:

Win_Name  :  Window Name (name referenced by)
Win_TR    :  Window Corrdinates
Win_TC    :  ""
Win_BR    :  ""
Win_BC    :  ""
Win_Color :  Window Color Scheme
Win_Up    :  Scroll direction 0 = Down, 1 = Up

SHORT:

Initialize a scrolling window for use by other _????Win() functions.

DESCRIPTION:

These functions comprise a set of functions that initialize, update, clear 
and kill scrolling windows that scroll information sent to them.

Each array element, up to the number that will fit inside the window 
coordinates, has it's first 20 positions filled with information about the 
window itself.  This allows the array to keep it's number of elements, length 
of each element, and the coordinates without any reference to some other 
information variables.  All that is created is the array itself, and it is 
self containing.  The passed text is added after position 20, and displayed 
from there as well.

Any fiddling with the first 27 bytes of the array is bound to cause problems.

Window motion is either from bottom to top, (1 = upward) or from top to 
bottom (0 = downward).

Each element of the array created has the following structure in it's first 
28 bytes:

String to Build: "xxxxxxxxxx###########xxxxxx#"
        Defined:  aaaaaaaaaabbccddeefffggggggh

a = Name of the Window  (MAX LENGTH OF NAME 10,space padded)
b = # of history positions to be kept (MAX maxrow())
c = window top left row               (MIN 0)
d = window top left col               (MIN 0)
e = window bottom right row           (MAX maxrow())
f = window bottom right col           (MAX maxcol())
g = window display color              ("W+/N")
h = Window Upward Motion              1=T 0=F


k_InitWin() initializes a scroll window called "exp<c1>" that operates within 
the coordinates n1,n2 to n3,n4.  It must be called prior to any call 
k_UpdtWin() that references this window.

NOTE:

This is an OLD Summer 87 function.

I bet you can tell by just looking at it that I was just DYING to get Clipper
5.0 and do this with statics.  Well, perhaps I will upgrade it....  This is
a perfect nomination for STATICIFYING, since it's pretty much what I have done
with PUBLICs and a function to manage their variable names.  It's almost like
STATIC emulation under Clipper S'87.


EXAMPLE:

* initialize two scroll windows
k_InitWin('Current',10,10,20,35)
k_InitWin('History',10,40,20,75)

* Update them with some text
k_UpdtWin('Current','Cur Line One')  // send to first window
k_UpdtWin('History','Hist Line One') // send this to second window

k_UpdtWin('Current','Cur Line Two')  // ditto
k_UpdtWin('History','Hist Line Two') // ditto

_ClrWin('History')  // clear the history window - current remains unchanged

k_UpdtWin('Current','Cur Line Three')  // add more
k_UpdtWin('History','Hist Line Three')

k_UpdtWin('Current','Cur Line Four')   // still more
k_UpdtWin('History','Hist Line Four')

* at this point, the "CURRENT" window contains:
*
*    Cur Line One
*    Cur Line Two
*    Cur Line Three
*    Cur Line Four
*
* and the "HISTORY" window contains
*
*   Hist Line Three
*   Hist Line Four

k_KillWin('Current')                   // kill both windows
k_KillWin('History')

* Both windows disappear!

******************************************************************************/
FUNCTION k_InitWin(Win_Name, Win_TR, Win_TC, Win_BR, Win_BC, Win_Color, Win_Up)
LOCAL    ictr
LOCAL    ar_name
LOCAL    Win_Len
LOCAL    i

if Win_Name = NIL
    k_Terminate('INTERNAL ERROR: Window Not Named at Intialization')
endif

if Win_TR = NIL .or. Win_TC = NIL .or. Win_BR = NIL .or. Win_BC = NIL
    k_Terminate('INTERNAL ERROR: Window Coordinates Not Intialized')
endif

if Win_Color = NIL
    Win_Color = ''
endif

if Win_Up = NIL
    Win_Up = '1'
endif

// parameter can also be pased as numeric - it will be converted //
if valtype(Win_Up) = 'N'
    Win_Up = ltrim(str(Win_Up))
endif

ar_name = win_name
win_len = win_br-win_tr+1

PUBLIC &win_name[win_len]

for ictr = 1 to win_len

    &win_name[ictr] =  substr(ar_name+space(10),1,10)+;
                       substr(ltrim(str(win_len+100)),2,2)+;
                       substr(ltrim(str(win_tr+100)),2,2)+;
                       substr(ltrim(str(win_tc+100)),2,2)+;
                       substr(ltrim(str(win_br+100)),2,2)+;
                       substr(ltrim(str(win_bc+1000)),2,3)+;
                       substr(win_color+space(6),1,6)+;     // if passed empty, use default color, else passed color
                       Win_Up+;                             // if NIL, will get the '1' else will use passed motion indicator
                       space(win_bc-win_tc)

next


RETURN(NIL)

