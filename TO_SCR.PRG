/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ToScr() --> NIL

PARAMETERS:

NONE

SHORT:

Set output device to screen.

DESCRIPTION:

k_ToScr() simply set's output to Screen (console), eliminating the need 
for three print redirection statements each time.

NOTE:



EXAMPLE:

k_ToScr()


Result: Output is directed to the screen via:

SET PRINT OFF
SET DEVICE TO SCREEN
SET CONS ON

******************************************************************************/

FUNCTION k_ToScr()

SET PRINT OFF
SET DEVICE TO SCREEN
SET CONS ON

RETURN(NIL)

