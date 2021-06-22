/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_FileOpenBrowse( nFRow, nFCol, nTRow, nTCol, cFileName, nTabSpaces ) --> NIL

PARAMETERS:

nFRow      : Browse window coordinates
nFCol      : "                       "
nTRow      : "                       "
nTCol      : "                       "
cFileName  : Name of disk file to open and browse with k_FileBrowse()
nTabSpaces : number of spaces to substitute for TABS.

SHORT:

k_FileOpenBrowse() is a front end to k_FileBrowse().  The latter function
expects a file HANDLE to an already open file.  k_FileOpenBrowse() opens
the file named in cFileName, and passes that handle on to k_FileBrowse().

DESCRIPTION:

See k_FileBrowse() for a description.

NOTE:

Neither k_FileOpenBrowse() not k_FileBrowse() draws a border or saves it's
screen area.

EXAMPLE:

k_FileOpenBrowse("TEMP.TXT")

******************************************************************************/
#include "fileio.ch"

FUNCTION k_FileOpenBrowse( nFRow, nFCol, nTRow, nTCol, cFileName, nTabSpaces )

LOCAL    nHandle := 0

if file(cFileName)

    nHandle = fopen(cFileName,FO_READ)

    if nHandle > 0
        k_FileBrowse( nFRow, nFCol, nTRow, nTCol, nHandle, nTabSpaces )
    endif

    fclose(nHandle)

endif

RETURN(NIL)

