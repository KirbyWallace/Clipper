/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_GetKey() --> nLastKeyCode

PARAMETERS:

None

SHORT:

Wait state INKEY(0)-like function.

DESCRIPTION:

k_GetKey() is a WAIT STATE wait that pauses program execution until a key is 
pressed.  The Clipper INKEY() value of the key pressed is returned.

NOTE:



EXAMPLE:

t = k_GetKey()

Result: Program pauses until a key is pressed. Key value is returned and 
assigned to "t".




******************************************************************************/
#include "klipper.ch"
#include "set.ch"

FUNCTION k_GetKey()
LOCAL    lCons := set(_SET_CONSOLE,FALSE)

WAIT ""

set(_SET_CONSOLE,lCons)

RETURN(lastkey())
