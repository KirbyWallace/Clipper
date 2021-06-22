/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_FWriteLine( nHandle, cText ) --> nBytesWritten

PARAMETERS:

nHandle : File handle from previous fopen() or fcreate()
cText   : Text string to write to file

SHORT:

Write a line of text to an ASCII file.

DESCRIPTION:

k_FWriteLine() writes a line of text to a specified file and appends a 
carriage return/line feed pair.

nHandle must be a valid file handle from a previous file open or file create.

NOTE:



EXAMPLE:

#include "fileio.ch"

LOCAL nHandle := fcreate('TEST.TXT',FC_NORMAL)

if ferror() = 0

    k_FWriteLine(nFileHandle, 'This is a line')
    k_FWriteLine(nFileHandle, 'This is another line')
    k_FWriteLine(nFileHandle, 'This is the last line')

    fclose(nHandle)
else
    tone(1000)
    ? 'Ooops!'
endif

Results:


TEST.TXT contains (if the write was sucessful):

This is a line
This is another line
This is the last line

******************************************************************************/
#include "klipper.ch"

FUNCTION k_FWriteLine( nHandle, cText )
RETURN(fwrite(nHandle,cText+LF))

