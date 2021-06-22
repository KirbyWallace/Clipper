/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_PeekSet(nSet) --> nStackSpaceLeft

PARAMETERS:

nSet  : The Clipper SET() number of the setting to peek.

SHORT:

Check the amount of "stack" space left on a _SetStack() stack.

DESCRIPTION:

k_PeekSet() looks at the next setting stack value without affecting it.

NOTE:

See k_PushSet() for a full description and examples.

EXAMPLE:



******************************************************************************/
#include "klipper.ch"
FUNCTION k_PeekSet(nSet)
RETURN(__SetStack(nSet,2,,TRUE))



