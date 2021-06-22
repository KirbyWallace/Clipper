/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Array2Str(xArray) --> cString

PARAMETERS:

xArray: Array containing elements of types C, N, D, L, or NIL

SHORT:

Convert an array to a single character string.

DESCRIPTION:

k_Array2Str() stores and array (either single or multiple dimension) in 
a string formatted such that k_Str2Array() can recreate it. 

It can be used in conjunction with Var2File() to store arrays (again, 
single or multiple dimension) to disk files.

The resulting string is only useful and meaningful to k_Str2Array() so any 
use of it without this other function is highly suspect.

NOTE:

k_Array2Str() will ignore any element that is not character, numeric, 
date, logical or another array of the same!! 

Code blocks are right out!  Same for Memos and "objects." 

Any attempt to use k_Array2Str() with these unsupported data types will 
render unpredictable results.

EXAMPLE:

t = {'a','b',{'1','2','3'},'d')

astr = k_Array2Str(t)

Result: aStr is a string containing the entire array.  It can now be restored 
to an array with "t = k_Str2Array(astr)", or it can be written to a disk file 
via k_Var2File(astr).


To completely store and restore an array to and from disk:

// going in...
aArray = {'a','b',{'1','2','3'},'d')

aStrArray = k_Array2Str(aArray)

k_Var2File(aStrArray,"FILE.EXT")

// coming out...
t = {}

aStrArray = k_File2Var("FILE.EXT")

t = k_Str2Array(aStrArray)

// or, simplified:

aArray1 = {'a','b',{'1','2','3'},'d')

k_Var2File(k_Array2Str(aArray),"FILE.EXT")

aArray2 = k_File2Var("FILE.EXT")

// or, a one-liner:

aArray2 = k_Str2Array(k_File2Var(k_Var2File(k_Array2Str(aArray1),"FILE.EXT")))

which essentially copies aArray1 to aArray2 via a disk file.

This is possible because k_Var2File() returns the name of the file the 
variable was stored in.  (See k_Var2File()).

******************************************************************************/
#include "klipper.ch"
#include "fileio.ch"

FUNCTION k_Array2Str(xArray)

LOCAL    cRetVal := ""
LOCAL    i

for i = 1 to len(xArray)

    do case

        case xArray[i] == NIL
            cRetVal += LF+'_XX'

        case valtype(xArray[i]) == 'C'
            cRetVal += LF+'_XC'+xArray[i]

        case valtype(xArray[i]) == 'D'
            cRetVal += LF+'_XD'+dtoc(xArray[i])

        case valtype(xArray[i]) == 'N'
            cRetVal += LF+'_XN'+ltrim(str(xArray[i]))

        case valtype(xArray[i]) == 'L'
            cRetVal += LF+'_XL'+iif(xArray[i],'T','F')

        case valtype(xArray[i]) == 'A'
            cRetVal += LF+'_XA'+ltrim(str(len(xArray[i])))+k_Array2Str(xArray[i])

    endcase

next

RETURN(cRetVal)


