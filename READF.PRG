/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ReadF() --> NIL

PARAMETERS:

None

SHORT:

An ultimately simplistic yet useful READ issuer.

DESCRIPTION:

k_ReadF() is a READ replacement that controls the cursor making sure that it 
is on at all reads and then returns it's state to what it was before the 
read! 

Programs that use k_Menu(), k_MenuA(), k_Prepare(), or k_KMenu(), need to use 
k_ReadF(), since these function set the cursor off.

NOTE:



EXAMPLE:

@ 10,10 SAY "Howdy!" GET howdy
k_ReadF()

******************************************************************************/
#include "setcurs.ch"
FUNCTION k_ReadF()
MEMVAR GetList

LOCAL OldCursor := set(_SET_CURSOR,SC_NORMAL)

READ

set(_SET_CURSOR,OldCursor)
RETURN(NIL)
