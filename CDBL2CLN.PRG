/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_CDbl2Cln( cByteStr ) --> nDecimalNum

PARAMETERS:

cByteStr : Eight byte string to convert to decimal value.

SHORT:

Convert C Double to Clipper Numeric.

DESCRIPTION:

k_CDbl2Cln() converts a native eight byte "C" Double Precision Integer to
it's equivalent Clipper NUMERIC.  It is used primarily for reading INTEGER 
and DECIMAL variables that have been stored in .MEM files.

The cByteStr must be obtained by way of a direct disk-read of bytes, or by 
way of a return value from a "C" function.

NOTE:

This function supports k_MemToArray() in MEMARRAY.PRG  Refer to that 
function for usage examples.

EXAMPLE:



******************************************************************************/

FUNCTION k_CDbl2Cln(cByteStr)
LOCAL WorkStr := ''
LOCAL    i
LOCAL    j
LOCAL    cSign
LOCAL    nExponent
LOCAL    cMantissa
LOCAL    nResult

if len(cByteStr) != 8
    RETURN(NIL)
endif

for i = 8 to 1 STEP -1
    WorkStr += k_IToBS(asc(substr(cByteStr,i,1)),7)
next

cSign     = substr(WorkStr,1,1)
nExponent = k_BtoI(substr(WorkStr,2,11))-1023

// cMantissa = '1'+substr(WorkStr,13,nExponent)

if nExponent < 0
    nResult   = k_BtoI('.'+repl('0',abs(nExponent)-1)+'1'+;
                substr(WorkStr,13))
else
    nResult   = k_BtoI('1'+substr(WorkStr,13,nExponent))+;
                k_BtoI('.'+substr(WorkStr,13+nExponent))
endif

if cSign = '1'
    nResult = nResult-(2*nResult)
endif

RETURN(nResult)

