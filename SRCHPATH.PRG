/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_SearchPath( cFileName ) --> cPathString

PARAMETERS:

cFileName : File name to search PATH for

SHORT:

Determine where in the OS PATH a specified file exists.

DESCRIPTION:

_Search_Path extracts and returns from the OS PATH the path that contains 
the file 'cFileName'.  If the file is not found, it returns "".

NOTE:



EXAMPLE:

Aassuming PATH = 'C:\APPS;C:\DOS;C:\UTILITY;C:\PROGRAMS' and that COMMAND.COM 
is in the DOS directory:

t = k_SearchPath('COMMAND.COM')

Result: t = 'C:\DOS'


Assume that QEDIT.EXE is in the UTILITY directory:

t = k_SearchPath('QEDIT.EXE')

Result: t = 'C:\UTILITY'

******************************************************************************/

FUNCTION k_SearchPath(cFileName)
LOCAL    cFPath    := ""
LOCAL    nSCount   := 0
LOCAL    cRetVal   := ""
LOCAL    acPaths   := {}
LOCAL    cSrchFile := ""

LOCAL    i

BEGIN SEQUENCE

cFPath=gete("PATH")

********************
* break path down. *
********************

cFPath=';'+cFPath+';'  // tag ';' on beginning and end for substr() use

**************************************************************************
* count the occurance of the char ';'.  represents the number of paths.  *
**************************************************************************

nSCount=0

for i = 1 to len(cFPath)
    nSCount=nSCount+iif(substr(cFPath,i,1) = ';',1,0)
next

if nSCount=0
    BREAK
else
    nSCount=nSCount-1  // trim off last count on last ';'
endif


*********************************************************
* Size the array and add individual path strings to it  *
*********************************************************

// DECLARE acPaths[nSCount]

asize(acPaths,nSCount)

for i=1 to nSCount
    // put the string
    acPaths[i] = substr(cFPath,(k_NthOccr(cFPath,';',i)+1),(k_NthOccr(cFPath,';',i+1)-k_NthOccr(cFPath,';',i))-1)
next

**************************************************************************************
* acPaths contains nSCount elements each containing a path from the DOS environment  *
* each one should end with a '\'                                                     *
**************************************************************************************

for i = 1 to nSCount

    if .not. empty(acPaths[i])

        if substr(acPaths[i],len(trim(acPaths[i]))-1,1) != '\'
            acPaths[i]=trim(acPaths[i])+'\'
        endif

    endif

next

*********************************************************************************
* step through each one looking for cFileName.  will exit func here if found()  *
*********************************************************************************

for i = 1 to nSCount

    cSrchFile=alltrim(acPaths[i]+cFileName)

    if file(cSrchFile)

        cRetVal = acPaths[i]
        EXIT

    endif

next

END SEQUENCE

RETURN(cRetVal)

