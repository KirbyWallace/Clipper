/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_IsOpen( cDBFileName ) --> cOpenStatus

PARAMETERS:

cDBFileName : database name or alias




SHORT:

Determine USE mode of database for current or other application.

DESCRIPTION:

k_IsOpen() determines if a specified database is open shared, open exclusively 
or not open by the current application or any other workstation on a network 
drive.

k_IsOpen() returns:

"E" if the specified database is open exclusively by the current or another 
application.

"S" if the specified database is open shared by the current or another 
application.

"" (empty) if the specified database is not open at all.

NOTE:



EXAMPLE:

t = k_IsOpen('TEST.DBF')

Result:  

If TEST.DBF is already open exclusively elsewhere t = 'E'
If TEST.DBF is already open SHARED elsewhere t = 'S'
If TEST.DBF is NOT open at all, anywhere t = '' ( ie, empty() )

******************************************************************************/
FUNCTION k_IsOpen(cDBFileName)
LOCAL    cRetVal := ''
LOCAL    nOldArea := SELECT()

USE (cDBFileName) EXCLUSIVE NEW ALIAS __FILE

if neterr()

    cRetVal = 'S'

    // cannot open exclusive, is open shared or exclusive already

    USE (cDBFileName) SHARED NEW ALIAS __FILE

    if neterr()
        // cannot open exclusive or shared, is open exclusive
        cRetVal = 'E'
    endif

endif

dbCloseArea()

if nOldArea != 0
    SELECT (nOldArea)
endif

RETURN(cRetVal)

