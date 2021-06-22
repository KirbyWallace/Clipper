/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Var2File(xValue, cFileName) --> cFileName

PARAMETERS:

xValue : Any variable of type C,D,N,L or an array of elements of these types.

SHORT:

Store data variables of any type, including arrays, to file.

DESCRIPTION:

k_Var2File() stores variables in a file format such that the 
k_File2Var() function can restore them. 

This makes it possible to pass data between two entirely different and 
separate programs.  Of course, this same thing might be easily done with a 
database file or .MEM file, but then again, that would require a database to 
exist, or a .MEM file (ruling out LOCALS being passed).  Besides, neither of 
these two methods could pass a LOCAL multi-dimentional, multi-data-type array 
intact to another program *at runtime!*

Variables may also be arrays, and arrays can be of mixed types and 
multi dimensional.

If the file name is not specified, then a file name of the first 
eight characters of the calling proc or function are used as the default 
file name and an extension of ".V2F" is given.

NOTE:

k_Var2File() will ignore any variable or any array element that is 
not character, numeric, date, logical or another array of the same!!

Code blocks are right out!  Same for Memos and "objects."

Any attempt to use k_Var2File() with these unsupported data types will 
render unpredictable results and incur the wrath of the terrible and 
fearsome DP/IS gods who will exact such horrendous punishment on you that 
you will ever despair of using undocumented features again.  You have 
been warned!

EXAMPLE:

cData = "ABC"

k_Var2File(cData,"FILE.EXT")

Result: a disk file called FILE.EXT is created and contains "ABC" in a 
format that can later be read by k_File2Var(). 


Example - allowing current proc/func name to name the target file:
*****************************************************************

#define ENGAGE(x)  k_Var2File(x)

FUNCTION EngageWarp(nWarpFactor)
LOCAL    cData = "Make it so, Number One!"

k_Var2File(cData,"DIRECTIVE.DAT")

ENGAGE(nWarpFactor)

RETURN(NIL)

*****************************************************************

In this example, the variable "cData" ends up in a file called 
DIRECTIV.DAT, because that's where we told it to put it.  But, 
nWarpFactor ends up in a different file that derives it's name from the 
name of the procedure/function that called it (which in this case, happens 
to be: ENGAGEWA.V2F.)

(If you do not see this, note that the #define statement will 
be preprocessesed into k_Var2File(x) - Thus, even if the file name 
was specified, it would be ignored because the PP will not pass it to 
the actual k_Var2File() function. And any time that you do not specify the 
file name, the default file name applies.)

Note that sucessive calls specifying the same file name overwrite any 
existing file by that name.

******************************************************************************/
#include "klipper.ch"
#include "fileio.ch"

FUNCTION k_Var2File(xValue,cFileName)

LOCAL    cFunctionFile
LOCAL    cWriteBuff
LOCAL    nHandle


if cFileName == NIL
    cFunctionFile = substr(procname(1),1,8)+'.v2f'
else
    cFunctionFile = cFileName
endif

do case

    case xValue == NIL
        cWriteBuff = 'X'

    case valtype(xValue) == 'C'
        cWriteBuff = 'C,'+xValue

    case valtype(xValue) == 'D'
        cWriteBuff= 'D,'+dtoc(xValue)

    case valtype(xValue) == 'N'
        cWriteBuff= 'N,'+ltrim(str(xValue))

    case valtype(xValue) == 'L'
        cWriteBuff= 'L,'+iif(xValue,'T','F')

    case valtype(xValue) == 'A'
        cWriteBuff= 'A,'+k_Array2Str(xValue)

endcase

nHandle = fcreate(cFunctionFile)

if nHandle != 0
    fwrite(nHandle,cWriteBuff,len(cWriteBuff))
    fclose(nHandle)
endif


RETURN(cFunctionFile)

