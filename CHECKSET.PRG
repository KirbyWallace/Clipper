/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_CheckSet(nSet) --> nStackSpaceRemaining

PARAMETERS:

nSet  : The Clipper SET() number of the setting to check.

SHORT:

Check Set Stack space available.

DESCRIPTION:

k_CheckSet() checks the space available on a setting stack.

NOTE:

See k_PushSet() for a full description and examples.

EXAMPLE:



******************************************************************************/
FUNCTION k_CheckSet(nSet)
RETURN(__SetStack(nSet,3))


