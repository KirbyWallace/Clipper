/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ArrayText( acArray, cFile, nWidth, lAppend ) --> nElementsWritten

PARAMETERS:

acArray : Single Dimension Array to be written to text file
cFile   : File to write/append to
nWidth  : Maximum width of elements to write (DEFAULT 1024)
lAppend : FALSE = Replace File  
          TRUE  = Append to File

SHORT:

Write an array to a text file.

DESCRIPTION:

k_ArrayText() is the opposite of k_TextArray().  It takes an array and writes 
it to a disk file. 

The array need not be exclusively composed of character elements. 
All non-character elements are converted to character type.  All 
elements converted to string are "alltrim()ed".  Logical values become "Y" 
or "N" in the output file. 

if nWidth is specified, then only the first nWidth characters of the 
element (after stringifying for non-char types) is written to each line in 
the output file.  If nWidth is not specified, then the entire array 
element, up to 1024 characters, is written. 

If lAppend is TRUE, the array is added to the bottom of the output file if 
it exists.  If lAppend is FALSE, then the output file is overwritten.

Unlike k_TextArray(), k_ArrayText() must be supplied with the name of a 
file that is !NOT OPEN! 

k_ArrayText() returns the number of array elements written.

NOTE:



EXAMPLE:

LOCAL acArray := {}
acArray = k_TextArray('AUTOEXEC.BAT')

aadd(acArray,'SET U_NAME=KWALLACE')

k_ArrayText(acArray, 'AUTOEXEC.BAT')

Result: AUTOEXEC.BAT is replaced with a copy of the original with 
an additional line (SET U_NAME=KWALLAC) added.

AUTOEXEC.BAT BEFORE:

@ECHO OFF
PROMPT $P$G
PATH=C:\DOS
C:\C600\BINB
C:\C600\BIN
C:\UT
C:\CLIPPER5\BIN
lh \dos\doskey
SET CLIPPER=F95
E00
SET OBJ=C:\CLIPPER5\OBJ
SET PLL=C:\CLIPPER5\INCLUDE
SET LIB=C:\C600\LIB
C:\CLIPPER5\LIB
SET INCLUDE=C:\C600\INCLUDE
C:\CLIPPER5\INCLUDE
c:\apps\clip_inc

AUTOEXEC.BAT AFTER:


@ECHO OFF
PROMPT $P$G
PATH=C:\DOS
C:\C600\BINB
C:\C600\BIN
C:\UT
C:\CLIPPER5\BIN
lh \dos\doskey
SET CLIPPER=F95
E00
SET OBJ=C:\CLIPPER5\OBJ
SET PLL=C:\CLIPPER5\INCLUDE
SET LIB=C:\C600\LIB
C:\CLIPPER5\LIB
SET INCLUDE=C:\C600\INCLUDE
C:\CLIPPER5\INCLUDE
c:\apps\clip_inc
SET U_NAME=KWALLACE

******************************************************************************/

#include "fileio.ch"
FUNCTION k_ArrayText( acArray, cFile, nWidth, lAppend )
LOCAL    nRetVal := 0
LOCAL    nHandle
LOCAL    i
LOCAL    cThisLine


lAppend = iif(lAppend = NIL,.F.,lAppend)

BEGIN SEQUENCE

    if !file( cFile )

        if (nHandle := fcreate( cFile ) ) = -1
            BREAK
        else

            fclose(nHandle)

        endif

    endif


    nHandle = iif(lAppend, fopen( cFile, FO_READWRITE ), fcreate( cFile ))

    if nHandle != -1

        if lAppend

            fseek(nHandle,0,FS_END)

        endif

        for i = 1 to len(acArray)


            cThisLine = alltrim(k_ToChar(acArray[i]))

            if valtype(nWidth) = 'N'
                cThisLine = substr(cThisLine,1,nWidth)
            endif

            k_FWriteLine(nHandle,cThisLine) ; nRetVal++

        next

        fclose(nHandle)

    endif


END SEQUENCE

RETURN(nRetVal)

