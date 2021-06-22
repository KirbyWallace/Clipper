/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_FCombine(cFileName, cInsFileName, nInsByte ) --> nBytesWritten

PARAMETERS:

cFileName    : File name to insert cInsFileName into
cInsFileName : File to be inserted into cFileName at nInsByte
nInsByte     : Byte number at which to begin insertion

SHORT:

Combine two files by inserting one into the other at a specified byte.

DESCRIPTION:

k_FCombine() combines two files by inserting one into the other at a specific 
byte or, optionally, appending it at EOF.

nInsByte will typically be derived from some other process which has opened 
the first file and determined where it needs to insert the second file.

It is handy for finding and replacing tokens in text or binary files with the 
contents of other files.

NOTE:

EXAMPLE:

k_FCombine('FILE1.TXT','FILE2.TXT',4290)

Result: FILE2.TXT is inserted into FILE1.TXT at byte offset 4290, (from 
beginning of file).

******************************************************************************/
#include "fileio.ch"
#include "klipper.ch"

FUNCTION k_FCombine( cFileName, cInsFileName, nInsByte )

LOCAL    nHandleInto
LOCAL    nHandleFrom
LOCAL    nHandleTemp

LOCAL    lRetVal    := FALSE

LOCAL    cTempPath  := gete("TEMP")
LOCAL    cTempFile  := ""

if !empty(cTempPath)
    if right(cTempPath,1) != "\"
        cTempPath += "\"
    endif
endif

cTempFile = cTempPath+padl(k_Dec2BaseX(seconds(),K_HEX),8,"0")

if file( cFileName ) .and. file( cInsFileName )

    nHandleInto = fopen( cFileName,    FO_READ )
    nHandleFrom = fopen( cInsFileName, FO_READ )
    nHandleTemp = fcreate( cTempFile,  FC_NORMAL )

    if ( nHandleInto != -1 ) .and. ( nHandleFrom != -1 ) .and. ( nHandleTemp != -1 )

        *-- if Insert position is not specified, append the file at the end
        nInsByte = iif(nInsByte = NIL, k_MaxFSize( nHandleInto ), nInsByte )

        k_FCopyBytes( nHandleInto, nHandleTemp, 0, nInsByte-1 )      // byte 0 through n of target file into temp file
        k_FCopyBytes( nHandleFrom, nHandleTemp )                     // ALL of insert file into temp file
        k_FCopyBytes( nHandleInto, nHandleTemp, nInsByte )           // byte n+1 through eof of target file into temp file

        fclose(nHandleInto) ; fclose(nHandleFrom) ; fclose(nHandleTemp)

        COPY FILE ( cTempFile ) TO ( cFileName )
        ERASE     ( cTempFile )
    
        * we made it all the way through...
        lRetVal := TRUE

    endif

endif

RETURN( lRetVal )

