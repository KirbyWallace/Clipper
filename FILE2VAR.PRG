/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_File2Var(cFileName) --> xVariable

PARAMETERS:

cFileName : File NAME, previously created by the k_Var2File() function.

SHORT:

Retrieve variable values from disk file written by k_Var2File().

DESCRIPTION:

See k_Var2File() for a complete discussion of these two functions.

k_File2Var() reads the data file specified in cFileName and returns the 
value of the data stored therein.  It is useful and meaningful only when 
used in combination with variables that have been stored to disk with 
the k_Var2File() function.

NOTE:

See also: k_Array2Str(), k_Str2Array(), k_Var2File()

EXAMPLE:

cString = "THIS IS A STRING"

k_Var2File(cString,"FILE.EXT")

cString = ""

cString = k_File2Var("FILE.EXT")

Result: cString = "THIS IS A STRING"

******************************************************************************/
#include "klipper.ch"
#include "fileio.ch"

FUNCTION k_File2Var(cFileName)
LOCAL    xRetVal := NIL
LOCAL    nHandle
LOCAL    i
LOCAL    cLine := ""

if file(cFileName)

    nHandle = fopen(cFileName,FO_READ)

    if nHandle != -1

        xRetVal = k_ReadLine(nHandle)

        do case

            case substr(xRetVal,1,1) = 'X'
                xRetVal = NIL

            case substr(xRetVal,1,1) = 'C'
                xRetVal = substr(xRetVal,3)

            case substr(xRetVal,1,1) = 'D'
                xRetVal = ctod(substr(xRetVal,3))

            case substr(xRetVal,1,1) = 'N'
                xRetVal = val(substr(xRetVal,3))

            case substr(xRetVal,1,1) = 'L'
                xRetVal = iif(substr(xRetVal,3)=='T',TRUE,FALSE)

            case substr(xRetVal,1,1) = 'A'

                cLine = ""

                while !k_FEOF(nHandle)

                    cLine += alltrim(k_ReadLine(nHandle))+LF

                end

                xRetVal = k_Str2Array(cLine)


        endcase

        fclose(nHandle)

    endif

endif

RETURN(xRetVal)

