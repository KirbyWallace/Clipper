/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Nullify( cFunctionRetVal, cRetType ) --> xValue

PARAMETERS:

cFunctionRetVal: The function call, with parameters, to execute
cRetType       : Return Value type.

SHORT:

Nullify an expression of any type in-line.

DESCRIPTION:

k_Nullify() accepts a function call as it's first parameter, and returns 
an empty value of the type specified in cRetType.

The basic purpose of this function is to allow you to concatenate 
several function calls together in a single expression without having 
to reconcile the different data types that those functions may return.

k_Nullify(INKEY(100),"C")
         |        |  |-------The Return Value Type (Char if NIL)
           --------
              |------------The Embedded Function

k_Nullify() nullifies any other function in an in-line expression by 
calling that function, and accepting it's return value as it own 
first parameter.  This function's return value is instead ignored, and 
the SECOND parameter to k_Nullify() specifies what sort of empty/nil value 
to return. 

"C" returns '',  "N" returns 0

If cRetType is not specified at all (i.e., NIL) then "" is returned 
by default.  If an invalid (not C or N) is specified, then the return value 
is an empty character type (""). 

Note that "k_X()" is a pseudonym that may be used in place of "k_Nullify()", 
and "k_Nulify()" is an alternate spelling.  They perform the same task, but in 
places where space is at a premium (ie, in the k_KMenu() Menu System where the 
menu allows only so many keystrokes in any given field), k_X() may save you 
some worthy space.

NOTE:



EXAMPLE:

This function does nothing other than allow me to do inline nulification 
of other function's return values.  This allows me to, say, add a pause into 
a dial string:

ATDT1800555-1212 + k_Nullify(inkey(3)) + '372* 886#'

It can also allow you to make two function calls in a single expression 
(such as, for example, the PREFUNC field in the _KMENU system) (Using the 
k_X() pseudonym):

k_X( 'TONE(1000,3)', "C" )+k_Nulify( 'k_Msg("Wrong Answer!")', "C" )

In this case, a beep will sound, followed by the Message "Wrong Answer", even 
though the two functions that did this return different values.  The 
k_Nullify() function returns a "" for each function allowing them to be 
combined with the "+" operator.

******************************************************************************/

FUNCTION k_Nullify(cFunctionRetVal,cRetType)
LOCAL    xRetVal

if cRetType = NIL
    xRetVal = ""
else
    do case

        case cRetType = 'C'
            xRetVal = ''

        case cRetType = 'N'
            xRetVal = 0

        otherwise
            xRetVal = ''
    endcase

endif


RETURN(xRetVal)

// for "spelling compatibility"
FUNCTION k_Nulify(cFunctionRetVal,cRetType)
RETURN(k_Nullify(cFunctionRetVal,cRetType))

// for pseudonym/shorthand usage
FUNCTION k_X(cFunctionRetVal,cRetType)
RETURN(k_Nullify(cFunctionRetVal,cRetType))
