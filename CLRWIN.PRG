/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ClrWin( Win_Name ) --> NIL

PARAMETERS:

Win_Name : Name of Window created by _Init_Win()

SHORT:

Clear a window created by _Init_Win().

DESCRIPTION:

k_ClrWin() clears a window that has been created by _Init_Win().

See _Init_Win() for details.

NOTE:



EXAMPLE:



******************************************************************************/

FUNCTION k_ClrWin(Win_Name)
LOCAL    i

for i = 1 to len(&Win_Name)
    &Win_Name[i] = substr(&Win_Name[i],1,27)
next

_Updt_Win(Win_Name)

RETURN(NIL)

