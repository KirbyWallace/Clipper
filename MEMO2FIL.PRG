/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Memo2File( cFile, cString ) --> lIsFile

PARAMETERS:

cFile   : File name to create (optionally with path)
cString : bytes to write to the file.

SHORT:

Write bytes to a disk file (ie, memowrit() replacement)

DESCRIPTION:

k_Memo2File() is a replacement for memowrit(), which has this nasty habit of
writing an EOF mark where one wasn't asked for.  No one uses EOFs anymore, get
real!  Anyway, k_Memo2File() writes the bytes, all the bytes, and nothing but
the bytes to the specified file.

NOTE:


EXAMPLE:

    memowrit("TEMP1.TXT","ABCDEFG")

    k_Memo2File("TEMP2.TXT","ABCDEFG")


The above two examples are equivalent with the following exception.  TEMP1.TXT
looks ike this, (where ">" indicates char(26)):

    ABCDEFG>


and TEMP2.TXT look like:

    ABCDEFG


******************************************************************************/
#include "fileio.ch"

FUNCTION k_Memo2File( cFile, cString )
LOCAL    nHandle

if ( nHandle := fcreate( cFile, FC_NORMAL ) ) > 0

    fwrite( nHandle, cString, len(cString))
    fclose( nHandle )

endif

RETURN( file(cFile) )

