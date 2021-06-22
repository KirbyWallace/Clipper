/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_KillWin( Win_Name ) --> NIL

PARAMETERS:

Win_Name : Name of Window created by k_InitWin()

SHORT:

Kill a window created by k_InitWin().

DESCRIPTION:

k_KillWin() Releases the window named in "Win_Name", equivalent of 
"RELEASE &Win_Name" but killWin() is better for readability.

NOTE:

See _InitWin for a complete description and examples.

EXAMPLE:



******************************************************************************/
FUNCTION k_KillWin(Win_Name)
    RELEASE &Win_Name
RETURN(NIL)

