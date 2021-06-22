/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_IsDBFMem( cFileName ) --> cMemField(s)

PARAMETERS:

cFileName : The name of the file to check

SHORT:

Return the name(s) of any memo fields in the specified (unopen) database.

DESCRIPTION:

k_IsDBFMem() returns the name(s) of MEMO fields in a database (separated by 
commas in the case of multiple memo fields). The database need not be open in 
any work area.

NOTE:



EXAMPLE:

t = k_IsDBFMem('TEST.DBF')

Result: t = "" if no mem fields
        t = "MEMO1" if one memo field called MEMO1
        t = "MEMO1,MEMO2" if two memo fields called MEMO1 & MEMO2

******************************************************************************/
#include "fileio.ch"
#include "klipper.ch"

FUNCTION k_IsDBFMem( cFileName )

LOCAL    nOldArea := select()
LOCAL    nHandle

LOCAL    cByte    := ' '
LOCAL    cRetVal  := ""

LOCAL    i

if file(cFileName)

    nHandle = fopen(cFileName,FO_READ)

    if nHandle != -1

        fread(nHandle,@cByte,1)

        fclose(nHandle)

        if cByte = chr(131)
            // mem fields exist

            USE (cFileName) SHARED READONLY NEW ALIAS __ISDBFMEM

            for i = 1 to fcount()
                if type(field(i)) == 'M'
                    cRetVal += ','+field(i)
                endif
            next

            cRetVal = substr(cRetVal,2)

            CLOSEAREA

            if nOldArea != 0
                SELECT (nOldArea)
            endif

        endif

    endif

endif

RETURN(cRetVal)

