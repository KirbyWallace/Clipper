/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ReadLine( nHandle, nLength ) --> cString

PARAMETERS:

nHandle   : file handle of previously opened file
nLength   : Maximum line length to read (default 1024)

SHORT:

Read a line of text from an ASCII file.

DESCRIPTION:

k_ReadLine() reads lines of text from a previously opened DOS text file.

nLength specifies the maximum line length to read.  If any line in the 
file exceeds this length, the remaining characters are read in in the 
next line.

NOTE:

See also k_FEOF()

EXAMPLE:

#include "fileio.ch"
handle = fopen('INPUT.TXT,FO_READ)

while !k_FEOF(handle)
    This_Line = k_ReadLine(handle)
end

Result:  Each line of the text file is read into the This_Line variable until 
all lines have been read.

******************************************************************************/


#include "fileio.ch"
#define  MAXCHARS 1024
#define  LF CHR(13)+CHR(10)

FUNCTION k_ReadLine(nHandle,nLength)
LOCAL    cRet_Val := ''
LOCAL    cCharBuffer
LOCAL    nPointer
LOCAL    nChars_Read
LOCAL    nLineFeedAt

cCharBuffer = space(iif(nLength = NIL,MAXCHARS,nLength))
nLength     = iif(nLength = NIL,MAXCHARS,nLength)

    // note current position
    nPointer = fseek(nHandle,0,FS_RELATIVE)

    (nChars_Read := fread(nHandle,@cCharBuffer,nLength))

    if ( nLineFeedAt := at(LF,cCharBuffer) ) > 0

        // got a line with Line Feed, ELSE return all of what we read

        cRet_Val = substr(cCharBuffer,1,nLineFeedAt-1)

        // reset pointer to next line
        fseek(nHandle,nPointer,FS_SET)
        fseek(nHandle,nPointer+nLineFeedAt+1,FS_SET) // 2 = crlf pair

    else

        cRet_Val = substr(cCharBuffer,1,nLength)

    endif


RETURN(trim(cRet_Val))

