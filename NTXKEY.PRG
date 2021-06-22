/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_NtxKey(cFileName, lNtx) --> cIndexExpression

PARAMETERS:

cFileName : Clipper NTX file from which to derive key expression
lNtx      : TRUE = Clipper NTX (DEFAULT) FALSE = dBASE NDX

SHORT:

Extract the index key expression from an index file (without db/ntx open).

DESCRIPTION:

k_NtxKey() returns the Index Key expression of the specified .NTX file.

If the file does not exist, a NUL (ie, empty()) string is returned.

NOTE:



EXAMPLE:

t = k_NtxKey('KLIPPER.NTX') // indexed on FNAME+LNAME

Result: t = 'FNAME+LNAME'


#define NDX .F.
t = k_NtxKey('KLIPPER.NDX',NDX) // indexed on NAME+STR(ACCOUNT)

Result: t = 'NAME+STR(ACCOUNT)'

******************************************************************************/

#include "fileio.ch"
#define KEYLEN 256

FUNCTION k_NtxKey(cFileName, lntx)
LOCAL    cRetVal := ''
LOCAL    nHandle
LOCAL    i

lNtx = iif(lNtx = NIL,.t.,lntx)


if file(cFileName)

    if (nHandle := fopen(cFileName,FO_READ)) != -1

        fseek(nHandle,iif(lNtx,22,24),FS_SET)

        cRetVal = freadstr(nHandle, KEYLEN)

        fclose(nHandle)

    endif

endif

RETURN(cRetVal)
