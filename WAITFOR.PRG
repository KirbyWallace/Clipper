/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_WaitFor( nWKey1, nWKey2, nWKey3, nWKey4, nWKey5, nWKey6 ) --> nKeyCode

PARAMETERS:

nWKey1 : INKEY() Code of key to wait for
nWKey2 : ""
nWKey3 : ""
nWKey4 : ""
nWKey5 : ""
nWKey6 : ""

SHORT:

Wait for the user to press any of (up to) 6 predefined keys, returning key.

DESCRIPTION:

_WaitKey() pauses execution of a program and waits for a key that matches 
one of the keys specified in the formal argument list. 

k_WaitFor() accepts up to six numeric arguments that represent Clipper 
INKEY() codes of keys to "wait for" and returns the INKEY() value of the 
key that was pressed.

NOTE:

k_WaitFor() is NOT a wait state.

EXAMPLE:

t = k_WaitFor(27,13,-9)

Result: Program pauses until ESC, ENTER or F10 is pressed, whereupon the 
value of the key that was pressed is returned as return value.

Clipper Preprocessor key labels can be used to make it clear which keys 
are being "waited" upon.

#include "inkey.ch"

t = k_WaitFor(K_ESC, K_ENTER, K_F10)

Result: user can hit keys until blue in the face, but until either Esc, 
ENTER, or F10 are pressed, nothing else happens.  The pressed key's INKEY() 
value is returned.

******************************************************************************/

FUNCTION k_WaitFor(nWKey1,nWKey2,nWKey3,nWKey4,nWKey5,nWKey6)
LOCAL    nIKey
LOCAL    i_Wait

**********************************************************
*  wait for specified key.  Up to six may be specified.  *
**********************************************************

nWKey1=iif(nWKey1 != NIL,nWKey1,0)
nWKey2=iif(nWKey2 != NIL,nWKey2,0)
nWKey3=iif(nWKey3 != NIL,nWKey3,0)
nWKey4=iif(nWKey4 != NIL,nWKey4,0)
nWKey5=iif(nWKey5 != NIL,nWKey5,0)
nWKey6=iif(nWKey6 != NIL,nWKey6,0)

while .t.

    while (i_wait := inkey()) == 0
    end

    nIKey = lastkey()

    if nIKey=nWKey1 .or. nIKey=nWKey2 .or. nIKey=nWKey3 .or. ;
       nIKey=nWKey4 .or. nIKey=nWKey5 .or. nIKey=nWKey6
        exit
    else
        if pcount() = 0
            tone(1000,1)
            tone(1000,1)
        else
            tone(1000,2)
        endif
    endif

end

RETURN(nIKey)

