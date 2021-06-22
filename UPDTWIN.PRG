/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

_Updt_Win( Win_Name, Win_Text ) --> NIL

PARAMETERS:

Win_Name : Name of window created by _Init_Win()
Win_Text : Text to send to window.

SHORT:

Update an k_InitWin() scrolling window with the specified text.

DESCRIPTION:

See InitWin() for a complete description.

NOTE:



EXAMPLE:

See k_InitWin() for example usage.

******************************************************************************/
FUNCTION k_UpdtWin(Win_Name, Win_Text)
LOCAL    i, t_key, old_color
LOCAL    Win_Up
LOCAL    Win_Color


if type(Win_Name) != 'A'
    * Specified Window does not exist
    return(NIL)
endif

if Win_Text = NIL
    Win_Text = ''
endif

********************************************************************************
* make sure we don't lose the first 27 places; they are the array's definition *
********************************************************************************
T_Key     = substr(&Win_Name[1],1,28)
Win_Up    = iif(substr( T_Key,28,1 ) = '1',.t.,.f.)
Win_Color = iif(!empty(substr(T_Key,22,6 ) ) ,substr(T_Key,22,6 ) ,set(_SET_COLOR) )

Old_Color = setcolor()
setcolor( Win_Color )

ains( &Win_Name, 1 )

******************************************
* restore the original array description *
******************************************

&Win_Name[1] = T_Key+Win_Text

if Win_Up

    for i = 1 to len(&Win_Name)
        @ ((val(substr(&Win_Name[i],17,2))+1)-i),val(substr(&Win_Name[i],15,2)) say space((val(substr(&Win_Name[i],19,3))-val(substr(&Win_Name[i],15,2)))+1)
        @ ((val(substr(&Win_Name[i],17,2))+1)-i),val(substr(&Win_Name[i],15,2)) say substr(&Win_Name[i],29,(val(substr(&Win_Name[i],19,3))-val(substr(&Win_Name[i],15,2))+1))
    next

else

    for i = 1 to len(&Win_Name)

        @ ((val(substr(&Win_Name[i],13,2))+i)-1),val(substr(&Win_Name[i],15,2)) ;
        say space((val(substr(&Win_Name[i],19,3))-val(substr(&Win_Name[i],15,2)))+1)

        @ ((val(substr(&Win_Name[i],13,2))+i)-1),val(substr(&Win_Name[i],15,2)) ;
        say substr(&Win_Name[i],29,(val(substr(&Win_Name[i],19,3))-val(substr(&Win_Name[i],15,2))+1))

    next

endif

setcolor(Old_Color)

RETURN(NIL)

