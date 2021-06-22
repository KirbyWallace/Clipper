/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_TextArray(cFileName, nWidth) --> acTextArray

PARAMETERS:

cFileName : Text file to read
nWidth    : Width of array elements (optional)

SHORT:

Loads the contents of a text file into an array

DESCRIPTION:

k_TextArray() reads the specified text file, adding each line to an 
array (which is returned as the function return value). 

If nWidth is specified, the array is created at that width and any 
characters in a line exceeding this length are truncated. 

If nWidth is NOT specified, then the array is sized to the width of
the longest line in the text file.  This is slower since one full read of 
the text file must be done in order to determine the longest element needed.

k_TextArray() returns the array with text data or empty() if the file does 
not exist or if the file is itself empty.

NOTE:

See also, k_ArrayText() which writes an array to a text file.

EXAMPLE:

LOCAL acFileData := {}

acFileData := k_TextArray('DATA.TXT', 80)

Result:  DATA.TXT is copied into an array called acFileData.  Any file 
data extending past column 80 is truncated.

*--------------------------------------------------------------

LOCAL acFileData := {}
acFileData := k_TextArray('DATA.TXT')

Result: DATA.TXT is copied into an array called acFileData.  The array 
is horizontally dimensioned (width) to accept the longest line in DATA.TXT  
In the default case, the longest line is 1024 chars. 

*--------------------------------------------------------------

LOCAL acFileData := {}
acFileData := k_TextArray('NOEXIST.TXT')

Result: In this case, it is presumed that NOEXIST.TXT does not exist, in 
which case, empty(acFileData) = TRUE.

******************************************************************************/
#include "fileio.ch"

FUNCTION k_TextArray( cFileName, nWidth )
LOCAL    acArray   := {}
LOCAL    cThisLine := ''
LOCAL    nHandle

if file(cFileName)

    nHandle = fopen(cFileName, FO_READ)

    if nHandle != -1

        while !k_FEOF(nHandle)

            cThisLine = k_ReadLine(nHandle)

            aadd(acArray, iif( nWidth = NIL, cThisLine, substr(cThisLine,1,nWidth)) )

        end


    endif

    fclose(nHandle)

endif

RETURN(acArray)

