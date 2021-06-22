/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Msg( cMsgText, nMsgLine, nBoxType ) --> NIL

PARAMETERS:

nMsgLine : Line to display message on
cMsgText : Text message to display

SHORT:

Present a boxed centered message without pausing execution.

DESCRIPTION:

k_Msg() displays a text message received as a parameter, centered inside of a 
red box.  It differs from k_Ack() in that it does not pause execution and does 
not save and restore the screen where it is written.  It's original purpose 
was to work with k_Ack() to display more than one line when an k_Ack() was 
issued.

NOTE:



EXAMPLE:

k_Msg('Howdy, stranger!',5)

******************************************************************************/

FUNCTION k_Msg(cMsgText,nMsgLine,nBoxType)
LOCAL    OldColor := setcolor('w+/r')

if nMsgLine = NIL
    nMsgLine = 10
endif

if nBoxType = NIL
    nBoxType = 2
endif

k_Box(nMsgLine,3,nMsgLine+2,77,nBoxType)

@ nMsgLine,05 say '< System Message>'
@ nMsgLine+1,40-(len(cMsgText)/2) say cMsgText

setcolor(OldColor)

RETURN(NIL)

