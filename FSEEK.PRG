/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_FSeek( xValue, cUDFFound, cUDFNFound ) -->lFound

PARAMETERS:

xValue : A value of any type to be SEEKed

SHORT:

SEEK without moving record pointer if value not found.

DESCRIPTION:

k_FSeek() is functionally similar to Clippers SEEK command, but differs in 
that k_FSeek() does not move the record pointer if the record is not found.  
If the record pointer is found, the record pointer is moved to the new 
record.

Additionally, two optional parameters may be passed containing the names 
of functions to be executed if the seek succeeds or fails.  cUDFFound, as 
the name implies, if linked into the program, is executed if the SEEK value 
is found.  The same is true for the cUDFNFound parameter.

If either of the UDFs specified are not present at run time, nothing 
happens, and the function returns the FOUND() value of the SEEK.

NOTE:

The record pointer is returned to the original record BEFORE the cUDFNFound 
UDF is called!

If either of the UDFs specified are not present at run time, nothing happens, 
and the function returns the FOUND() (TRUE or FALSE) value of the SEEK.

EXAMPLE:

GOTO nRec
? recno()        // 145

SEEK cNoFind

? found()        // .f.
? eof()          // .t.
? recno()        // (last record+1)

GOTO nRec

? recno()        // 145

k_FSeek( cNoFind )

? found()        // .f.
? eof()          // .f.
? recno()        // 145


k_FSeek(nVal,"WhatToDoIfFound('Yep')","WhatToDoIfNOTFound('Nope')")

Result: nVal is SEEKed on the current index.  If FOUND(), then 
WhatToDoIfFound('Yep') is called (if present), else the record pointer is 
returned to the original record and WhatToDoIfNOTFound('Nope') is called (if 
present).

******************************************************************************/

#include "klipper.ch"

FUNCTION k_FSeek(xValue, cUDFFound, cUDFNFound)

LOCAL    nRec := recno()
LOCAL    xNul
LOCAL    lRetVal := FALSE

if cUDFFound = NIL
    cUDFFound = ""
endif

if cUDFNFound = NIL
    cUDFNFound = ""
endif

SEEK xValue

if found()

    lRetVal = TRUE

    if type(cUDFFound) == 'UI'
        xNul = (&cUDFFound)
    endif

else

    lRetVal = FALSE

    GOTO nRec

    if type(cUDFNFound) == 'UI'
        xNul = (&cUDFNFound)
    endif

endif


RETURN(lRetVal)

