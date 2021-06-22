/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

__SetStack()

PARAMETERS:



SHORT:

_Internal SESTACK function engine. (Not for direct use).

DESCRIPTION:



NOTE:

SetStack is an internal function only and should not be called directly by 
any application.

EXAMPLE:



******************************************************************************/

**********************************************************************************************************************************
* Internal Stack "engine" - Not to be called directly.  Use PushSet()/PopSet()/PeekSet()/CheckSet()
**********************************************************************************************************************************

FUNCTION __SetStack(nSet, nMode, xVal, lLook)

STATIC   __STACK[38,10]

LOCAL    xRetVal := NIL
LOCAL    i, j

// 1 = push, other = pop

do case

    case nMode = 1 // push
        for i = 1 to 10

            if __STACK[nSet,i] = NIL

                __STACK[nSet,i] = xVal

                xRetVal = i // return the stack depth

                EXIT

            endif

        next

        if i = 11
            xRetVal = -1
        endif

    case nMode = 2 // pop

        for i = 1 to 10

            if __STACK[nSet,i] = NIL

                if i = 1

                    xRetVal = NIL

                else

                    xRetVal = __STACK[nSet,i-1]

                endif

                if !lLook
                    __STACK[nSet,i-1] = NIL
                endif

                EXIT

            endif

        next

        if i = 11

            xRetVal = __STACK[nSet,i-1]

            if !lLook
                __STACK[nSet,i-1] = NIL
            endif

        endif

    case nMode = 3 // check

        j = 0

        for i = 10 to 1 STEP -1

            if __STACK[nSet,i] = NIL
                j++
            else
                EXIT
            endif

        next

        xRetVal = j


endcase

RETURN(xRetVal)


