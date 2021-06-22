/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_PopSet(nSet) -> xStackSetting

PARAMETERS:

nSet  : The Clipper SET() number of the setting to pop.

SHORT:

Pop the next setting of a k_PushSet() stack.

DESCRIPTION:

PopSet() pops the next set stack value.

NOTE:

See k_PushSet() for a full description and examples.

EXAMPLE:



******************************************************************************/
#include "klipper.ch"
FUNCTION k_PopSet(nSet)
RETURN(__SetStack(nSet,2,,FALSE))


