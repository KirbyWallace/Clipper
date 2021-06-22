/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_True() --> lTRUE

PARAMETERS:

None

SHORT:

Return TRUE in an inline expression (as a function call).

DESCRIPTION:

_True can be used in places where a function MUST be called, but there may 
not be a function to be called.

NOTE:

I covered this in k_False() (since I got to it first in the list), so see 
k_False() for a discussion of why this function may be useful.  Hey - It could 
happen!

EXAMPLE:

ValidExp = iif(type(_ValFunc) != 'U','_ValFunc()','k_False()')

@ 10,10 GET variable VALID (ValidExp)

In this example, the VALID is hard coded and therefore, MUST have an 
expression to evaluate.  VALID followed by nothing would cause a runtime 
error.

******************************************************************************/
FUNCTION k_True()
RETURN(.t.)

