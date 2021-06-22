/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

__WSSaveScreen( nHandle ) --> NIL

PARAMETERS:

nHandle : File name from previous fopen()/fcreate()

SHORT:

Save screen to existing and already open file, in WordStar format.

DESCRIPTION:

__WSSaveScreen() is identical to k_WSSaveScreen() except that in this case
you pass the handle of an already opened or created file.

The contents of the screen are written to this file handle and the 
handle remains open when the function returns.

It is useful in situations where you want to save the screen contents to 
a file and then continue writing other information to the same file, but 
you do not want to have to reopen the file following k_SaveScreen() 
(which closes the file when done). 

For an example, see k_Prepare(), which uses the __SaveScreen()
counterpart function in it's error recording errorblock function.

NOTE:



EXAMPLE:

__WsSaveSceen( nHandle )

Result: The screen is saved in WordStar format to the already open file 
specified by nHandle).  

__WSSaveScreen() appends to any existing data in the file.

******************************************************************************/


#include "fileio.ch"
#include "inkey.ch"
#include "klipper.ch"

FUNCTION __WSSaveScreen(nHandle)
LOCAL ScreenData := SaveScreen(0,0,MaxRow(),MaxCol())
LOCAL ScreenText := ''
LOCAL i
LOCAL Ret_Val

BEGIN SEQUENCE

    if nHandle == NIL
        BREAK
    endif

    if nHandle == 0
        BREAK
    endif

    for i = 1 to len(ScreenData) step 2
        ScreenText += substr(ScreenData,i,1)
    next

    fseek(nHandle,0,FS_END)

    for i = 1 to len(ScreenText)

        fwrite(nHandle,substr(ScreenText,i,1)+chr(28))

        if i % 80 = 0
            fwrite(nHandle,LF)
        endif
    next

END SEQUENCE

RETURN(Ret_Val)

