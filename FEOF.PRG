/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_FEOF( nHandle ) --> lEOFStatus

PARAMETERS:

nHandle : handle of previously opened file

SHORT:

Check for end of file reached.

DESCRIPTION:

k_FEOF() is used in conjunction with k_ReadLine() to test for End-Of-File.  It 
returns TRUE when the file pointer is at EOF.

NOTE:



EXAMPLE:

#include "fileio.ch"
handle = fopen('INPUT.TXT,FO_READ)

while !k_FEOF(handle)
    This_Line = k_ReadLine(handle)
    ? This_Line
end


Result:  Each line of the text file is read into the This_Line variable 
and displayed until all lines have been read and k_FEOF() then returns TRUE, 
exiting the loop.

******************************************************************************/

#include "fileio.ch"
FUNCTION k_FEOF(nHandle)
LOCAL nCurrentPointer := fseek(nHandle,0,FS_RELATIVE)
LOCAL nEOFPosition := fseek(nHandle,0,FS_END)
LOCAL k := ' '

fseek(nHandle,nCurrentPointer,FS_SET) // reset pointer to original position

RETURN(iif(nCurrentPointer >= nEOFPosition,.t.,.f.))

