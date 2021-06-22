/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_CDbl2Cld( cByteStr ) --> dDate

PARAMETERS:

cByteStr : Eight bytes string to convert to Clipper date type.

SHORT:

C Double to Clipper Date

DESCRIPTION:

Clipper stores dates as an eight byte double.

k_CDbl2Cld() converts a native "C" Double Precision Integer to it's
equivalent Clipper Date.  It is used primarily for reading date variables 
that have been stored in .MEM files.

The cByteStr must be obtained by way of a direct disk-read of bytes, or by 
way of a return value from a "C" function.

NOTE:

This function supports k_MemToArray() in MEMARRAY.PRG  Refer to that function 
for usage examples.

EXAMPLE:

fread(nFHandle,@BYTES,8)

t = k_CDbl2Cld(BYTES)

Result:

t = <a Clipper Date type>

******************************************************************************/

FUNCTION k_CDbl2Cld(cByteStr)
RETURN(ctod('')+k_CDbl2CLn(cByteStr))

