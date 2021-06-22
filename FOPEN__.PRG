/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_FOpen(cFileName, nMode) --> nHandle

PARAMETERS:

cFileName : File name to open/create
nMode     : KFO_APPEND   : Append to bottom of file
            KFO_OVERWRITE: Overwrite at Beginning
            KFO_TRUNC    : Truncate to Zero Length and overwrite at beginning

SHORT:

OS File Open with optional file pointer placements.

DESCRIPTION:

k_FOpen() opens/creates files and positions the file pointer according to 
the directive in nMode.  In any case, the specified file is created if it 
does not exist.

k_FOpen() Always opens for Read/Write.

k_FOpen() returns the file handle of the opened/created file, or -1 if an 
error occured.  This can also be tested with FERROR() manually.

Return Codes:

-1 General File Error (DOS ERROR - Use FERROR() to Check)
-2 Unknown Error - your guess is as good as mine
-3 Either cFileName or nMode was not passed or was NIL
-4 Either nMode was not numeric or cFileName was not character
-5 nMode was out of range (USE KLIPPER.CH KFO_* directives!!!)

NOTE:



EXAMPLE:

Assuming that NEWFILE.TXT does not exist, all three of the following 
are identical in operation:

k_FOpen("NewFile.TXT",KFO_APPEND)
k_FOpen("NewFile.TXT",KFO_OVERWRITE)
k_FOpen("NewFile.TXT",KFO_TRUNC)

Now, assuming that DATAFILE.TXT exists and has data:

nHandle = k_FOpen("DataFile.TXT",KFO_APPEND)

Appends any data written to nHandle (with standard clipper low level file 
functions) to the bottom of the existing file.

DATAFILE.TXT CONTAINS:

<tof>
LINE111111111111111111111111111111
LINE222222222222222222222222222222
LINE333333333333333333333333333333
<eof>

nHandle = k_FOpen("DATAFILE.TXT",KFO_APPEND)

fwrite(nhandle,"Yow!",4)

DATAFILE.TXT -NOW- CONTAINS:

<tof>
THIS IS OTHER DATA-TOO.11111111111
LINE222222222222222222222222222222
LINE333333333333333333333333333333Yow!
<eof>

k_FOpen("DataFile.TXT",KFO_OVERWRITE)

Overwrites any data at the beginning of the file, for the length of the 
data written, leaving data AFTER that point intact. 

DATAFILE.TXT CONTAINS:

<tof>
LINE111111111111111111111111111111
LINE222222222222222222222222222222
LINE333333333333333333333333333333
<eof>

nHandle = k_FOpen("DATAFILE.TXT",OVERWRITE)

fwrite(nhandle,"THIS IS OTHER DATA",18)
fwrite(nhandle,"-TOO.",4)

DATAFILE.TXT -NOW- CONTAINS:

<tof>
THIS IS OTHER DATA-TOO.11111111111
LINE222222222222222222222222222222
LINE333333333333333333333333333333
<eof>

k_FOpen("DataFile.TXT",KFO_TRUNC)

DATAFILE.TXT CONTAINS:

<tof>
LINE111111111111111111111111111111
LINE222222222222222222222222222222
LINE333333333333333333333333333333
<eof>

nHandle = k_FOpen("DATAFILE.TXT",KFO_TRUNC)

fwrite(nhandle,"THIS IS OTHER DATA",18)

DATAFILE -NOW- CONTAINS:

<tof>
THIS IS OTHER DATA
<eof>

******************************************************************************/
#include "fileio.ch"
#include "klipper.ch"

FUNCTION k_FOpen(cFileName,nMode)
LOCAL    nHandle := -2


if cFileName = NIL .or. nMode = NIL
    nHandle = -3
else

    if valtype(nMode) = 'N' .and. valtype(cFileName) = 'C'

        if nMode >= 1 .and. nMode <= 3

            do case

                case nMode = KFO_APPEND

                    if file(cFileName)

                        nHandle = fopen(cFileName,FO_READWRITE)

                        if nHandle != KFO_FAIL
                            fseek(nHandle,0,FS_END)
                        endif

                    else

                        nHandle = fcreate(cFileName,FC_NORMAL)

                    endif


                case nMode = KFO_OVERWRITE

                    if file(cFileName)

                        nHandle = fopen(cFileName,FO_READWRITE)

                        if nHandle != KFO_FAIL
                            fseek(nHandle,0,FS_SET)
                        endif

                    else

                        nHandle = fcreate(cFileName,FC_NORMAL)

                    endif

                case nMode = KFO_TRUNC

                    nHandle = fcreate(cFileName,FC_NORMAL)
            end

        else
            nHandle = -5
        endif
    else
        nHandle = -4
    endif

endif

RETURN(nHandle)

