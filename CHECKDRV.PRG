/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_CheckDrive( cDrive ) --> lDriveReady

PARAMETERS:

cDrive : Drive to Check

SHORT:

Check if Drive is available for READ/WRITE.

DESCRIPTION:

k_CheckDrive() checks to see if the specified drive is available and 
writable.


Return Values:

0 - Disk is available for R/W
1 - Disk is unavailable for R/W

k_CheckDrive() will ignore any colon in the drive specification.

NOTE:

CheckDrive() uses the Clipper !/RUN command.

EXAMPLE:

lIsDriveA := k_CheckDrive('A')

Result: If Drive A is avaliable then k_CheckDrive() will return TRUE, 
else, FALSE.


lIsDriveA = k_CheckDrive('A:')

Result: Same as above.  Colon is ignored if passed.

******************************************************************************/

#include "fileio.ch"
FUNCTION k_CheckDrive(cDrive)
LOCAL    nFHandle
LOCAL    nRetVal := 1

cDrive = k_Convert(cDrive)  // get rid of any sloppy programmer junk

if !file(cDrive+':_NUL')

    nFHandle := fcreate(cDrive+':_NUL')

    if ferror() = 0
        // all's well
        fclose(nFHandle)
        ferase(cDrive+':_NUL')
        nRetVal = 0 // r+w

    endif

else

    // is file, so is disk!

    if ( nFHandle := fopen(cDrive+':_NUL',FO_READWRITE) ) != -1
        // is readable, writable disk.

        fclose(nFHandle)
        nRetVal = 0 // is rw, just happened to have _NUL as file on disk

    endif

endif

RETURN(nRetVal)

