/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_WSPopScrSave() --> lSuccess

PARAMETERS:

None

SHORT:

Save screen to user specified file in WordStar format.

DESCRIPTION:

k_PopScrSave() is a screen capture utility that can be linked into your 
program and activated with a SET KEY TO call.  The function can also be 
called directly.

The screen is saved in generic DOS text format after supplying an eight 
character file name.

Returns TRUE if successfully saved, else FALSE

NOTE:

See also: k_PopScrSave() which operates similarly, but with a plain ASCII 
text file.

EXAMPLE:

SET KEY ALT_F10 to k_PopScrSave()

Result: When ALT-F10 is pressed, the user is prompted for a file name.  The 
screen contents (minus the file name prompt) are saved in a plain ASCII text 
file of the users choice name.

******************************************************************************/
#include "fileio.ch"
#include "inkey.ch"
#include "klipper.ch"

FUNCTION k_WSPopScrSave()
RETURN(k_WSSaveScreen(alltrim(k_GetStr('Save File Name: ',8))+'.SCR'))

