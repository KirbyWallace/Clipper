/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_FCopyBytes( nHandleFrom, nHandleTo, nByteFrom, nByteTo ) --> nBytesCopied

PARAMETERS:

nHandleFrom : Handle of open file to read from
nHandleTo   : Handle of open file to copy to (append or overwrite to)
nByteFrom   : Byte in source file to read from (default BOF)
nByteTo     : Byte in source file to read to   (default EOF)

SHORT:

Copy bytes from source file to target file, overwritting/appending target file.

DESCRIPTION:

NOTE:

The file being copied from as well as the file being copied to must be open,
and their handles must be passed to k_FCopyBytes().  The target file is
overwritten from it's current position on.  If the target file is at EOF,
bytes are appended.

Neither file pointer is restored to it's original position, rather they are
left pointing at their new position.

EXAMPLE:

******************************************************************************/
#include "fileio.ch"
#define  MAX_COPY_BUFFER    4096

FUNCTION k_FCopyBytes( nHandleFrom, nHandleTo, nByteFrom, nByteTo )

LOCAL    cCopyBuffer  := space(MAX_COPY_BUFFER)
LOCAL    nBytesRead   := 0
LOCAL    nBytesToRead := 0

LOCAL    i

nByteFrom = iif( nByteFrom = NIL, 0, nByteFrom )
nByteTo = iif( nByteTo = NIL, k_MaxFSize(nHandleFrom)-1, nByteTo )

nBytesToRead = ( nByteTo - nByteFrom ) + 1

fseek( nHandleFrom, nByteFrom, FS_SET )

while nBytesToRead > 0

    nBytesRead := fread( nHandleFrom, @cCopyBuffer, min(nBytesToRead,MAX_COPY_BUFFER) )

    fwrite( nHandleTo, cCopyBuffer, nBytesRead )
    
    nBytesToRead -= nBytesRead

end

RETURN( NIL )

FUNCTION k_MaxFSize( nHandle )
LOCAL    nHere    := fseek( nHandle, 0, FS_RELATIVE )
LOCAL    nMaxByte := fseek( nHandle, 0, FS_END )

fseek( nHandle, nHere, FS_SET )

RETURN( nMaxByte )

