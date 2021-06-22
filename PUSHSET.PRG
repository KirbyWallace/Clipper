/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_PushSet(nSet,xVal) --> nStackSpaceRemaining

PARAMETERS:

nSet  : The Clipper SET() number of the setting to push
xVal  : The value to be pushed onto the setting stack

SHORT:

Push a Clipper set() setting onto a SetStack() stack.

DESCRIPTION:

k_PushSet(), k_PopSet(), and k_PeekSet() are a set of functions that allow you 
to save and retrieve any of Clipper's SET settings by pushing and popping 
from an internal stack.

All three functions have a stack that allows up to 10 settings to be saved 
for each of Clipper's 38 SET settings.

k_PushSet() accepts TWO parameters, the first - nSet - corresponds to each 
of Clipper's numeric SET() settings.  You should use the Clipper 
Pre-processor directives for referencing these settings.

For example, to save the setting of SET EXACT, specify:

k_PushSet(_SET_EXACT,<value>)

k_PushSet()'s second parameter - xVal - is the value to be saved. k_PushSet() 
is the only function that takes more than one function argument/parameter. 
 This can be of any data type used by SET() (ie, Char, Num, or Logical). 

All Push/Pop operations use the LIFO method.  That is, the last value 
pushed onto the stack for any given set stack is the first one popped off 
of the stack.

The functions maintain separate stacks for each of the 38 different 
SET settings.  So, pushing a value onto the _SET_EXACT stack does not 
affect the _SET_DEVICE stack, or any other stack. 

When a particular stack is full, any attempt to push another value onto 
that stack will be ignored and -1 will be returned indicating an 
"error condition."

Likewise, any attempt to pop more values off the stack than have been 
pushed onto the stack will return NIL.

To facilitate stack management, the function k_CheckSet() can be used 
to determine the number of values currently on any given stack.  Using 
this function, you can determine if there are any values on the stack 
before attempting to pop them, and also, conversely, whether there is any 
room left on the stack before attempting to push new values.

The function k_PeekSet() can be used to return the value of any given 
stack without actually popping it's value off the stack.  This allows you 
to use k_PeekSet() in a similar manner as k_CheckSet() to determine if there 
is a value on the stack before attempting to pop it.

k_PeekSet() cannot tell you, however, if there is any room left on a stack.  
You must use k_CheckSet() for that purpose.

NOTE:

This code is already available for compiling under DEMOS\SETSTACK.

EXAMPLE:

This example shows the full range of Push/Pop/Peek/Check usage filling and 
emptying a stack:

i = 1

while k_CheckSet(_SET_DECIMALS) >= 1

    // space still available on stack

    k_PushSet(_SET_DECIMALS,i++)
    ? 'Remaining Space on Stack: '+str(k_CheckSet(_SET_DECIMALS))

end

while k_PeekSet(_SET_DECIMALS) != NIL

    // more values to pop...

    set(_SET_DECIMALS,k_PopSet(_SET_DECIMALS))
    ? 2/3, 'Remaining Space on Stack: '+str(k_CheckSet(_SET_DECIMALS))

end

******************************************************************************/
#include "klipper.ch"
#include "set.ch"

FUNCTION k_PushSet(nSet,xVal)
RETURN(__SetStack(nSet,1,xVal))

