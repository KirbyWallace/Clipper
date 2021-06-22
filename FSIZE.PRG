/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_FSize( xFile ) --> nFileSize

PARAMETERS:

xFile: file name *OR* handle

SHORT:

Determine the size of a file.

DESCRIPTION:

k_FSize() returns the size of the specified file in bytes.

If xFile is of type char, then k_FSize() assumes a file name of a file TO 
BE OPENED.  If the file is already open, then pass the file handle returned 
by a previous call to Clipper's fopen() function.

If you specify a file handle of an already open file, the file pointer 
is reset to it's original position when k_FSize() returns.

If you specify a file handle that is not valid, the result is unpredictable.

If you specify a file that does not exist, -1 is returned.

If you fail to specify xFile, the return value is -1.

If you specify a file name that cannot be opened, the return value is -1.

NOTE:

k_FSize() is a legacy function - written before directory() was introduced in 
version 5.x of Clipper.

Nevertheless, k_FSize() is less trouble, doing away with the need to create 
an array simply to get the file size of a single file.

EXAMPLE:

EXAMPLE: LOCAL t := k_FSize('TEST.DAT')

Result: t = 50887 //size of TEST.DAT

******************************************************************************/
#include "fileio.ch"
FUNCTION k_FSize( xFile )
LOCAL    nRetVal := -1
LOCAL    nHandle
LOCAL    nOldPtr

do case

    case valtype( xFile ) == 'C'

        if file( xFile )

            nHandle = fopen(xFile)

            if nHandle != -1
                nRetVal = fseek(nHandle,0,FS_END)
            endif

            fclose(nHandle)

        endif

    case valtype( xFile ) == 'N'


        nOldPtr = fseek(xFile,0,FS_RELATIVE)

        nRetVal = fseek(xFile,0,FS_END)

        fseek(xFile,nOldPtr,FS_SET)


endcase

RETURN(nRetVal)

