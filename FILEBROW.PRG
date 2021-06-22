/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_FileBrowse( nFRow, nFCol, nTRow, nTCol, nHandle, nTabSpaces ) --> lFilePtr

PARAMETERS:

nFRow     : Window Coordinates
nFCol     : ""
nTRow     : ""
nTCol     : ""
nHandle   : file handle of previously opened file
nTabSpaces: Number of spaces to convert tabs to (DEFAULT: 4)

SHORT:

Browse a text file  - will accomodate many megabytes in size.

DESCRIPTION:

k_FileBrowse() is a, well, file browser.  The file to be browsed must have 
been previously opened.  Data on any line that falls beyond the right 
margin defined by the window coordinates is truncated (from view).

If nTabSpaces = 0, then no spaces are inserted in place of tabs and the tab 
character (chr(9)) is displayed.

NOTE:

In consideration of speed, nTabSpaces is NOT type checked any farther 
than NIL.  If it is NIL, no tab replacement occurs. If it is !NIL, then 
a numeric is expected and anything else will cause a run-time error.

Note that k_FileBrowse() will change the current position of the file pointer  
returning it's last position as the functions return value.

Use PgUp and PgDn (or up/down arrows) to view, left and right arrows to pan,
and ESC to quit.

The file size is limited, theoretically, to approximately 8 MB in 25x80 mode. 
In 43x80, appx. 14 MB, and in 50x132, appx. 27 MB.

k_FileBrowse() saves and restores the screen underneath it.

See also: k_FileOpenBrowse() which is exactly like k_FileBrowse() but accepts
the file's name instead of an existing handle.  k_FileOpenBrowse() opens
and closes the specified file itself.

EXAMPLE:

FUNCTION main()
LOCAL    nHandle

// assuming TEST.TXT is in the current directory
nHandle = fopen("test.txt",FO_READ)

if ferror() = 0

    k_FScreen('File Browse Test')
    k_PopBox(3,0,MaxRow(),MaxCol())
    k_FileBrowse(4,1,MaxRow()-1,MaxCol()-1,nHandle)

    fclose(nHandle)

endif

RETURN(NIL)

******************************************************************************/

#include "klipper.ch"
#include "fileio.ch"
#include "inkey.ch"

// PAN_COLS is set to one half of the width of the screen.  Thus the screen
// pans one-half screen left or right in response to K_LEFT and/or K_RIGHT.

#define PAN_COLS int((nTCol-nFCol)/2)

FUNCTION k_FileBrowse(nFrow, nFCol, nTRow, nTCol, nHandle, nTabSpaces)

LOCAL  apFilePage := {}
LOCAL  nKey       := 0
LOCAL  nPtr       := 0
LOCAL  lGoodKey   := TRUE
LOCAL  nLeftCol   := 1
LOCAL  i
LOCAL  cFileBrowScreen := savescreen(nFrow, nFCol, nTRow, nTCol)

nTabSpaces = iif(nTabSpaces = NIL,0,nTabSpaces)

BEGIN SEQUENCE

fseek(nHandle,0,FS_SET)

aadd(apFilePage,fseek(nHandle,0,FS_RELATIVE))
nPtr++

while .t.


    if lGoodKey

        @ nFRow, nFCol CLEAR TO nTRow, nTCol

        if nTabSpaces = 0

            for i = 0 to nTRow-nFRow
                @ nFRow+i,nFCol SAY substr(k_ReadLine(nHandle),nLeftCol,nTCol-nFCol)
            next

        else

            for i = 0 to nTRow-nFRow
                @ nFRow+i,nFCol SAY substr(strtran(k_ReadLine(nHandle),chr(9),repl(' ',nTabSpaces)),nLeftCol,nTCol-nFCol)
            next

        endif

    endif

    nKey = inkey(0)

    lGoodKey = TRUE

    do case

        case nKey = K_ESC .or. nKey = K_ENTER
            EXIT

        case nKey = K_LEFT

            fseek(nHandle,apFilePage[nPtr],FS_SET)

            nLeftCol = iif(nLeftCol >= PAN_COLS, nLeftCol-PAN_COLS,nLeftCol)

        case nKey = K_RIGHT

            fseek(nHandle,apFilePage[nPtr],FS_SET)

            nLeftCol += PAN_COLS

        case nKey = K_PGDN .or. nKey = K_DOWN

            if !k_FEOF(nHandle)
                if nPtr = len(apFilePage)
                    aadd(apFilePage,fseek(nHandle,0,FS_RELATIVE))
                endif

                nPtr++
                fseek(nHandle,apFilePage[nPtr],FS_SET)
            else
                tone(1000,1)
            endif

        case nKey = K_PGUP .or. nKey = K_UP

            if nPtr > 1
                nPtr--
            endif

            fseek(nHandle,apFilePage[nPtr],FS_SET)

        OTHERWISE

            tone(1000,1)
            lGoodKey = FALSE

    end

end

END SEQUENCE

restscreen(nFrow, nFCol, nTRow, nTCol, cFileBrowScreen )

RETURN(fseek(nHandle,0,FS_RELATIVE))

