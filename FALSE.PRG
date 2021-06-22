/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_False() --> lFALSE

PARAMETERS:

None

SHORT:

Return FALSE.

DESCRIPTION:

k_False() simply returns FALSE.  It can be useful in embedding a logical 
value in inline assignments where a statement cannot be used, or to return a 
value where a default value may be needed.

NOTE:



EXAMPLE:

lDoFunc = iif(IS_DEFINED_FUNCTION1, Function1(), k_False() )

if lDoFunc
    ? 'We did Function1() already! Are we bored?'
endif

******************************************************************************/

FUNCTION k_False()
RETURN(.f.)

