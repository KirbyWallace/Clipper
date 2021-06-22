/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_CurVol() --> cDriveLette

PARAMETERS:

None

SHORT:

Return the current DOS drive letter.

DESCRIPTION:

k_CurVol() returns the drive letter of the currently logged drive.

NOTE:

This function uses an external DOS command to work.  You must 
therefore reserve enough conventional RAM to load COMMAND.COM in the Clipper 
R variable (SET CLIPPER= r045).  Different versions of DOS require 
different amounts of RAM to load the Command Interpreter.  Refer to your 
DOS Manual for information.

A good guide is the size of the COMMAND.COM of your version of DOS.  
This number is a little high, but should be safe for practical application.

You may also use the DOS command MEM /C (in DOS version 5.0 or higher) to 
see what the actual size of the Command Interpreter is for your version 
of DOS).

EXAMPLE:

Current_Drive = k_CurVol()

Result: 'C' (assuming drive C: is the current drive)

******************************************************************************/

FUNCTION k_CurVol()
LOCAL cDriveLetter := ' '
LOCAL nFHandle

!CD > CURVOL._-_

if file('CURVOL._-_')

    nFHandle = fopen('curvol._-_')

    if ferror() = 0

        if fread(nFHandle,@cDriveLetter,1) != 1
            cDriveLetter = '0'
        endif

        fclose(nFHandle)

    endif

    ferase('CURVOL._-_')

endif

RETURN(cDriveLetter)

