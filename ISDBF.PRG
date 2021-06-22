/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_IsDBF( cFileName ) --> lIsDBF

PARAMETERS:

cFileName : The name of the file to check

SHORT:

Determine if a file is a dBASE III+ compatible database file.

DESCRIPTION:

k_IsDBF() returns TRUE if cFileName has a 03h or 83h in the first byte 
(indicating a POSSIBLE dBase III+ database)

NOTE:

Just because a file DOES have an 03h or 83h in the first byte does not 
necessarily mean that the file actually IS a dBASE database.  Use judgement 
when using this function.

See also k_IsDBFMem() which returns information regarding the presence of 
MEMO fields in a database.

EXAMPLE:

t = k_IsDBF('TEST.DBF')

Result: t = TRUE

******************************************************************************/
#include "fileio.ch"
FUNCTION k_IsDBF( cFileName )
LOCAL    lRetVal := .f.
LOCAL    nHandle
LOCAL    cByte := ' '

if file(cFileName)

    nHandle = fopen(cFileName,FO_READ)

    if nHandle != -1

        fread(nHandle,@cByte,1)

        if cByte = chr(3) .or. cByte = chr(131)
            lRetVal = .t.
        endif

        fclose(nHandle)

    endif

endif

RETURN(lRetVal)

