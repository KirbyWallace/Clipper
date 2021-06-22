/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_SaveScreen( cFileName ) --> lSuccess

PARAMETERS:

cFileName: save file name

SHORT:

Save screen to a text file.

DESCRIPTION:

k_SaveScreen() saves the contents of the screen to a text file specified 
in cFileName.

If the file specified in cFileName does not exist, it is created. If it 
does exist, the contents of the screen are appended to it.

Returns TRUE if successfully saved, else FALSE.

NOTE:



EXAMPLE:

k_SaveScreen('THIS_SCR.TXT')

Results: The current contents of the screen are saved to a file 
called THIS_SCR.TXT.  If THIS_SCR.TXT does not exist, it is created, else 
it is appended to.

******************************************************************************/

#include "fileio.ch"
#include "inkey.ch"
#include "klipper.ch"

FUNCTION k_SaveScreen(cSaveFileName)
LOCAL ScreenData := SaveScreen(0,0,MaxRow(),MaxCol())
LOCAL ScreenText := ''
LOCAL i
LOCAL nFHandle
LOCAL Ret_Val

if empty(cSaveFileName)
    cSaveFileName = 'SCREEN.SCR'
endif

for i = 1 to len(ScreenData) step 2
    ScreenText += substr(ScreenData,i,1)
next

if !file(cSaveFileName)
    nFHandle = fcreate(cSaveFileName)
else
    nFHandle = fopen(cSaveFileName)
endif

if (Ret_Val := ferror()) = 0

    fseek(nFHandle,0,FS_END)

    for i = 1 to len(ScreenText)

        fwrite(nFHandle,substr(ScreenText,i,1))

        if i % (maxcol()+1) = 0
            fwrite(nFHandle,LF)
        endif
    next


    fclose(nFHandle)
else

    tone(3000,10)

endif

RETURN(Ret_Val)

FUNCTION __SaveScreen(nHandle)
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

        fwrite(nHandle,substr(ScreenText,i,1))

        if i % (maxcol()+1) = 0
            fwrite(nHandle,LF)
        endif
    next

END SEQUENCE

RETURN(Ret_Val)

