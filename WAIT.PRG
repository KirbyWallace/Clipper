/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Wait( nSeconds ) --> NIL

PARAMETERS:

nSeconds : number of seconds to pause program execution

SHORT:

Pause program execution for nSeconds, regardless of keyboard activity.

DESCRIPTION:

k_Wait() stops program execution much like inkey().  The difference is 
that unlike INKEY(), which continues as soon as a key is pressed, 
k_Wait() waits the number of seconds specified regardless. 

It is useful where you need to display a message and be sure that no 
pending keyboard keystrokes vanish it before it can be read. 

There is no return value from this function.

NOTE:

Keyboard input is still buffered while waiting and will be processed as 
soon as the wait period is expired.

See also: k_WaitFor() which stops program execution until one of a set 
of specified keys are pressed.

EXAMPLE:

k_Wait(5)

Result: Program execution pauses for 5 seconds no matter what the user does 
on the keyboard.

******************************************************************************/
FUNCTION k_Wait(nSeconds)
LOCAL    nThen := seconds()

while ( seconds() - nThen < nSeconds )
end

RETURN(NIL)

