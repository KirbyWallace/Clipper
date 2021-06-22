/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_FPeekByte( nHandle, nMode, nBytes ) --> cString

PARAMETERS:

nHandle : File handle from previous fopen()
nMode   : 1 (KFP_NEXT) - next bytes (DEFAULT)
        : 2 (KFP_PREV) - previous bytes
nBytes  : Number of bytes to read (DEFAULT: 1 byte)

SHORT:

Read bytes before or after the current position without moving file pointer

DESCRIPTION:

k_FPeekByte() allows you to look ahead at incoming bytes, or take a look 
a previous bytes without moving the current file pointer.  This is handy when 
you need to know something about the upcoming bytes, or need to take another 
look at previous bytes without losing your current position.

This is essentialy the same thing as simply making note of the current file 
pointer, going about your business, then FSEEK()ing your old position.  This 
is just much easier and requires no variable declarations on your part.

NOTE:



EXAMPLE:

t = fopen('THE_CRYPT.AGH')

fseek(t,100,FS_SET)     // now sitting at byte 100

fread(t,@data,1)

if data = chr(13)

    ? 'Yikes!'

    if k_FPeekByte(t,KFP_NEXT,1) = chr(10)

        ? 'There is a two headed CRLF pair standing in the   '
        ? 'entrance to the crypt.  You are about to be eaten '
        ? 'by a grue. Goodbye...'

    endif

endif


******************************************************************************/

#include "klipper.ch"
#include "fileio.ch"

FUNCTION k_FPeekByte(nHandle,nMode,nBytes)
LOCAL    cRetVal  := space(iif(valtype(nBytes) = 'N',nBytes,1))
LOCAL    nOldFPtr := fseek(nHandle,0,FS_RELATIVE)
LOCAL    nFPtrLim


if nMode     = KFP_NEXT

    nFPtrLim = fseek(nHandle,0,FS_END) // note end position
    fseek(nHandle,nOldFPtr,FS_SET)     // get back to original position

    if nBytes > (nFPtrLim-nOldFPtr)
        nBytes = (nFPtrLim-nOldFPtr)+1
        cRetVal = space(nBytes)
    endif

    fseek(nHandle,1,FS_RELATIVE)
    fread(nHandle,@cRetVal,nBytes)
    fseek(nHandle,nOldFPtr,FS_SET)

elseif nMode = KFP_PREV

    if nBytes > (nOldFPtr)
        nBytes = nOldFPtr-1
        cRetVal = space(nBytes)
    endif

    if nBytes > 0
        fseek(nHandle,-(nBytes),FS_RELATIVE)
        fread(nHandle,@cRetVal,nBytes)
        fseek(nHandle,nOldFPtr,FS_SET)
    endif

else
    cRetVal = ""
endif

RETURN(cRetVal)


