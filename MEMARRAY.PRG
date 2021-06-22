/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_MemToArray( cMemFile ) --> aArray

PARAMETERS:

cMemFile: .MEM file to load to array.

SHORT:

Load .MEM file to local array instead of main application memory.

DESCRIPTION:

k_MemToArray() loads the contents of a specified .MEM file into an array 
rather than into the program's main memory.

NOTE:



EXAMPLE:

LOCAL aArrayName := k_MemToArray('test.mem')

The resulting array is multi-dimensional, one element per memory variable 
and each element containing elements that contain, NAME, TYPE, LEN, DEC, 
and CONTENTS of each variable in the .MEM file.

******************************************************************************/
#include "fileio.ch"
#define eVAR_NAME  aVar_Data[i,1]
#define eVAR_TYPE  aVar_Data[i,2]
#define eVAR_LEN   aVar_Data[i,3]
#define eVAR_DEC   aVar_Data[i,4]
#define eVAR_DATA  aVar_Data[i,5]

FUNCTION k_MemToArray(cMemFile)

LOCAL FHandle := fopen(cMemFile)
LOCAL aVar_Data[0,5]
LOCAL cDataSpace := space(1) // fread() buffer
LOCAL nReadSize              // fread() length



// Code Block for Reading .MEM File
LOCAL bReadFunc := { | nReadSize | fread(FHandle,@cDataSpace,nReadSize), ;
                   substr(cDataSpace,1,nReadSize) }

LOCAL nOld_Decimals := set(_SET_DECIMALS,52), Ret_Val := -1, i := 1

while .t.

    cDataSpace = space(11)

    if empty( eval(bReadFunc,11) )    // eof()
        exit
    else
        aadd(aVar_Data, {space(11),;  // Name
                         space(1), ;  // Type
                                0, ;  // Len
                                0, ;  // Dec
                          space(1) }) // Slot for data
    endif

    // save var_name just read by block

    eVAR_NAME  = substr(cDataSpace,1,at(chr(0),cDataSpace)-1)
    eVAR_TYPE  = chr(asc(eval(bReadFunc,1))-128)

    fseek(FHandle,4,FS_RELATIVE) // skip filler

    eVAR_LEN   = asc(eval(bReadFunc,1))
    eVAR_DEC   = asc(eval(bReadFunc,1))

    fseek(FHandle,14,FS_RELATIVE) // skip filler

    // based upon eVAR_TYPE, set size of fread() buffer to accomodate data
    // and read data into that buffer

    do case

        case eVAR_TYPE = 'C' // 195
            * character

            cDataSpace = space( eVAR_LEN + eVAR_DEC * 256 )
            eVAR_DATA  = eval(bReadFunc, len(cDataSpace) )

        case eVAR_TYPE = 'D' // 196
            * date

            cDataSpace = space(8)
            eVAR_DATA  = k_CDbl2CLd( eval(bReadFunc, 8 ))

        case eVAR_TYPE = 'L'  // 204
            * logical

            cDataSpace = space(1)
            eVAR_DATA  = iif( asc(eval(bReadFunc, 1 )) > 0,.t.,.f.)

        case eVAR_TYPE = 'N' //206
            * numeric

            cDataSpace = space(8)
            eVAR_DATA  = k_CDbl2CLn( eval(bReadFunc, 8 ))

    endcase

    i++

end

adel(aVar_Data,len(aVar_Data))

Ret_Val := aVar_Data

fclose(FHandle)

set(_SET_DECIMALS,nOld_Decimals)

RETURN(Ret_Val)

