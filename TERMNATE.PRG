/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Terminate( cTermMsg, nErrorLevel ) --> NIL

PARAMETERS:

cTermMsg    : message to display at termination
nErrorLevel : Errorlevel to set before returning to OS

SHORT:

General purpose application death-invoker with ERRORLEVEL set.

DESCRIPTION:

k_Terminate() ends program operation.  It clears the screen, displays the 
cTermMsg message, closes all files and QUITs with ERRORLEVEL set to 
specified value.

NOTE:



EXAMPLE:

if UNRECOVERABLE_ERROR
    k_Terminate('An unrecoverable error has occured',1)
endif

Result:  The message is dislayed and the program is terminated with 
an ERRORLEVEL = 1.

******************************************************************************/

FUNCTION k_Terminate(cTermMsg,nErrorLevel)

SET color   TO
SET cursor  ON
SET print   OFF
SET device  TO  screen

CLOSE ALL
CLEAR SCREEN

? cTermMsg
?
? 'Press any key...'

inkey(0)

if valtype(nErrorLevel) = 'N'
    errorlevel(nErrorLevel)
endif

QUIT

RETURN(NIL)

