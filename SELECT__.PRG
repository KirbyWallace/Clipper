/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Select( xSelectArea ) --> lSelectStatus

PARAMETERS:

xSelectArea

SHORT:

Select a work area by number or alias.

DESCRIPTION:

k_Select() is a general purpose work area selector.  It selects a work 
area either by work area ALIAS (character argument), or by work area 
number (numeric argument). 

Optionally, k_Select() can be used to CLOSE a work are by calling 
k_Select() with no parameters, however, this is not recommended as it leads 
to poor and evem misleading readability. 

The function is useful because the way that Clipper evaluates 
character expressions is different from the way it evaluates 
numeric expressions.  Character expressions can be evaluated, even 
from character variables with no parenthesis.  Numeric expressions 
however must be evaluated inside parenthesis.

k_Select() negates the need to determine which format to use. Simply pass 
the argument to the k_Select() function, and it will evaluate the 
expression correctly depending upon the expression type.

k_Select() returns a logical value indicating .T. if no error occured, or 
.F. if an error did occur.

NOTE:

The file name is __select.prg to avoid conflict with the Clipper SELECT 
command. 



EXAMPLE:

SELECT 1
USE bufget INDEX budget ALIAS BudgetFile

t = "BudgetFile"
u = 1

k_Select(t)
k_Select(u)
k_Select('BudgetFile')

Result: All three function calls accomplish the same thing. They ALL 
select the Budget File work area. 

SELECT 1
USE bufget INDEX budget ALIAS BudgetFile

...
...

k_Select()

Result: The work area/Database File (and Indexes) is closed

******************************************************************************/
FUNCTION k_Select(xSelectArea)
LOCAL    lRet_Val := .t.

if xSelectArea == NIL
    use
else
    if valtype(xSelectArea) == 'N'
        // numeric select
        SELECT (xSelectArea)
    else
        if valtype(xSelectArea) == 'C'
            // alias select
            SELECT xSelectArea
        else
            // error
            lRet_Val = .T.
            tone(1000,1)
        endif
    endif
endif

RETURN(lRet_Val)

