/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Bold( cWhat ) --> cString

PARAMETERS:

cWhat : Text String

SHORT:

Double strike a print string.

DESCRIPTION:

k_Bold() prints the contents passed in the "cWhat" param THRICE at the 
current print head coords, giving a BOLD appearance.  Is useful since it 
can be used as part of an in-line expression.

NOTE:



EXAMPLE:

@ 10,10 say k_Bold('THIS IS A LINE')
@ 10,10 say 'I said' + k_Bold(' NOW ') + 'Mister...'

******************************************************************************/
FUNCTION k_Bold(cWhat)
LOCAL    B_Row, B_Col

if cWhat = NIL
    cWhat = ""
endif

b_row = prow()
b_col = pcol()

@ b_row,b_col say cwhat
@ b_row,b_col say cwhat
@ b_row,b_col say cwhat
@ b_row,b_col say ''

// The parameter is passed back unaltered so that the expression evaluates
// to "itself" and is printed as the return value of the function.  This is
// necessary because the method of use is to @..SAY, and there must be some-
// thing returned to SAY.

RETURN(cWhat)

