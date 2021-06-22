/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Str2Array(cString) --> xArray

PARAMETERS:

cString : String previously created by k_Array2Str()

SHORT:

Convert _Arr2Str()'s string back to an array.

DESCRIPTION:

k_Str2Array() is used to restore an array previously "stringified" 
specifically by k_Array2Str().

NOTE:

See Also Array2Str(), k_File2Var(), k_Var2File()

EXAMPLE:

t = {'ABCDEFG','HIJKLMN',{'o','p','q'},,1,2,3,'RSTUVWXZ'}

t = k_Str2Array(cArrayStr1)

Result: t now contains a copy of the array stored in cArrayStr.  Yes, 
multidimensional, multi-type (including NIL element) arrays are supported.

******************************************************************************/

#include "klipper.ch"
#include "fileio.ch"

FUNCTION k_Str2Array(cString)
LOCAL    xArray  := {}
LOCAL    nHandle := 0
LOCAL    cHandle := ""
LOCAL    cTemp   := ""
LOCAL    cLine   := ""

LOCAL    nElements
LOCAL    i

for i = 1 to 1000

    cHandle = '____'+ltrim(str(i))+'.tmp'

    if !file(cHandle)
        nHandle = fcreate(cHandle)
        exit
    endif

next

if nHandle != 0

    fwrite(nHandle,cString,len(cString))

    fseek(nHandle,0,FS_SET)

    while !k_FEOF(nHandle)

        cLine = k_ReadLine(nHandle)

        do case

            case substr(cLine,3,1) = 'X'
                aadd(xArray,NIL)

            case substr(cLine,3,1) = 'C'
                aadd(xArray,substr(cLine,4))

            case substr(cLine,3,1) = 'D'
                aadd(xArray,ctod(substr(cLine,4)))

            case substr(cLine,3,1) = 'N'
                aadd(xArray,val(substr(cLine,4)))

            case substr(cLine,3,1) = 'L'
                aadd(xArray,iif(substr(cLine,4) == 'T',TRUE,FALSE))

            case substr(cLine,3,1) = 'A'

                nElements = val(substr(cLine,4))

                cTemp := ""

                for i = 1 to nElements

                    cLine = k_ReadLine(nHandle)

                    cTemp += cLine+LF

                    // another array embedded here will add n lines for ONE element
                    // compensate accordingly.

                    if substr(cLine,3,1) = 'A'
                        i -= val(substr(cLine,4))
                    endif

                next

                aadd(xArray,k_Str2Array(cTemp))

        endcase

    end

    fclose(nHandle)
    ERASE (cHandle)

endif

RETURN(xArray)


