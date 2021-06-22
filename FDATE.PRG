/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_FDate(cFileName) --> dFileDate

PARAMETERS:

cFileName : Name of file to check

SHORT:

Get date of specified DOS file.

DESCRIPTION:

k_FDate() returns the DOS date stamp from any DOS file.

The cFileName parameter may be fully qualified with a path.  If the file name 
contains no path, the current directory is assumed.

k_FDate() returns and empty date (ie, CTOD("")) if the specified file does not 
exist.

NOTE:



EXAMPLE:

? k_FDate('TEST.TXT')
? k_FDate('D:\TEST\TEST.TXT')

******************************************************************************/
#include "klipper.ch"
#include "directry.ch"

FUNCTION k_FDate(cFileName)

LOCAL    dFDate      AS TYPE_DATE
LOCAL    axFileInfo  AS TYPE_ARRAY

axFileInfo = directory(cFileName)

if len(axFileInfo) == 1
    dFDate = axFileInfo[1,F_DATE]
endif

RETURN(dFDate)

