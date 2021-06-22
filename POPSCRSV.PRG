/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_PopScrSave() --> lSuccess

PARAMETERS:

None

SHORT:

Screen capture utility function (ASCII).

DESCRIPTION:

k_PopScrSave() is a screen capture utility that can be linked into 
your program and activated with a SET KEY TO call.  The function can also 
be called directly.

The screen is saved in generic DOS text format after supplying an 
eight character file name.

Returns TRUE if successfully saved, else FALSE.

NOTE:

See also k_WSPopScrSave() which saves to a WordStar (tm) format.

EXAMPLE:

SET KEY ALT_F10 to k_PopScrSave()

******************************************************************************/
#include "fileio.ch"
#include "inkey.ch"
#include "klipper.ch"

FUNCTION k_PopScrSave()
RETURN(k_SaveScreen(alltrim(k_GetStr('Save File Name: ',8))+'.SCR'))


