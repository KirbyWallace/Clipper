/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_WSSaveScreen( cFileName ) --> lSuccess

PARAMETERS:

None

SHORT:

Screen capture utility (WordStar format).

DESCRIPTION:

k_WSSaveScreen() saves the contents of the screen to a text file specified 
in cFileName, in WordStar format.

If the file specified in cFileName does not exist, it is created. If it 
does exist, the contents of the screen are appended to it.

Returns TRUE if successfully saved, else FALSE

NOTE:

This function is similar to k_WSPopScrSave(), only the file name is 
specified in a parameter to the function rather than prompted for at 
run-time.

EXAMPLE:

k_WSSaveScreen('THIS_SCR.TXT')

Results: The current contents of the screen are saved to a file 
called THIS_SCR.TXT in a WORDSTAR compatible format. If the file 
THIS_SCR.TXT does not exist, it is created, else it is appended to.

******************************************************************************/

#include "fileio.ch"
#include "inkey.ch"
#include "klipper.ch"

FUNCTION k_WSSaveScreen(cSaveFileName)
LOCAL ScreenData := SaveScreen(0,0,MaxRow(),MaxCol())
LOCAL ScreenText := ''
LOCAL i
LOCAL fHandle
LOCAL Ret_Val

if empty(cSaveFileName)
    cSaveFileName = 'SCREEN.SCR'
endif

for i = 1 to len(ScreenData) step 2
    ScreenText += substr(ScreenData,i,1)
next

if !file(cSaveFileName)
    fhandle = fcreate(cSaveFileName)
else
    fhandle = fopen(cSaveFileName)
endif

if (Ret_Val := ferror()) = 0

    fseek(fhandle,0,FS_END)

    for i = 1 to len(ScreenText)

        fwrite(fhandle,chr(27)+substr(ScreenText,i,1)+chr(28))

        if i % 80 = 0
            fwrite(fhandle,chr(13)+chr(10))
        endif
    next


    fclose(fhandle)
else

    tone(3000,10)

endif

RETURN(Ret_Val)

