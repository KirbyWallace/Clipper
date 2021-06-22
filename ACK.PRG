/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Ack( cAckMsg, cAckColor, nBoxType ) --> cAckMsg

PARAMETERS:

cStatement : Acknowledge statement


SHORT:

Present a boxed message and wait for user acknowledgement.

DESCRIPTION:

k_Ack() presents a message on the screen and prompts for an 
acknowledgement from the user via either ENTER or ESC.

Unlike k_Msg(), k_Ack() pauses program execution until the proper key 
is pressed.  That key can be tested with "lastkey()" 

Note that when nBoxType = BOXNONE (no border) the Box Message ("Message 
- Press Enter") does not appear either.  In all cases, the k_KeyList() 
line always contains instructions in the color of the k_Ack() box.

k_Ack() returns whatever string was passed to it.  This lets you "stack" one 
or more commands at once without having to specify the string again.

Example: Instead of two strings:

k_Ack('Big Time Error: Something Died')
k_Terminate('Big Time Error: Something Died')

Try: One String Declaration, used twice:

k_Terminate(k_Ack('Big Time Error: Something Died'))

In this case, k_Ack() returns to k_Terminate() what it was given.  k_Terminate() 
then receives the same message, but the string is only defined once.






NOTE:

See k_Box() for a list of valid box border types.

EXAMPLE:

k_Ack('Something Horrible Happened!!')

Result: The message is presented in a red box, and program execution 
stops until either ESC or ENTER is pressed.

******************************************************************************/

FUNCTION k_Ack(cAckMsg,cAckColor,nBoxType)

LOCAL    cOldColor := setcolor()
LOCAL    cAckScr   := savescreen(10,00,13,MaxCol())
LOCAL    cKeyLine  := savescreen(MaxRow(),00,MaxRow(),MaxCol())
//LOCAL    nRetVal   := 0

if cAckColor = NIL
    cAckColor = 'w+/r'
endif

if nBoxType = NIL
    nBoxType = 1
endif

tone(2000,2)

setcolor(cAckColor)

k_Box(10,3,10+2,MaxCol()-2,nBoxType)
k_KeyList('Press the ENTER or ESC key to acknowledge the message...',cAckColor)

@ 10,05 say iif(nBoxType != 6,'< Message - Press Enter >','')

@ 11,(MaxCol()/2)-(len(k_ToChar(cAckMsg))/2) say k_ToChar(cAckMsg)


setcolor(cOldColor)

//nRetVal = k_WaitFor(13,27)
k_WaitFor(13,27)

restscreen(10,00,13,MaxCol(),cAckScr)
restscreen(MaxRow(),00,MaxRow(),MaxCol(),cKeyLine)


RETURN(cAckMsg)
//RETURN(nRetVal)

