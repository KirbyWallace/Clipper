/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Dial(cPhoneNum, [nComPort]) --> nResult

PARAMETERS:

cPhoneNum : formatted phone number string to dial
nComPort  : Optional: Com Port DEFAULT: 1

SHORT:

Dial a number on the specified com port.

DESCRIPTION:

k_Dial() receives a formatted string containing a phone number to dial. 

The specified com port is opened, the number is dialed and the function 
closes the com port and returns a numeric return value as soon as any key 
is pressed.

RETURN VALUES:

0  - No Error
-1 - Com Port Open Error
-2 - Com Port Write Error
n  - Scan Code of Key Pressed

To dial a number, present a message indicating that the user should press 
any key when the phone rings or to hang up.  Call k_Dial().  When the 
phone rings, the user can press any key to issue a hang-up and the com 
port will be closed.  By this time, the user has picked up the handset, so 
the phone line will not be hung up.

Special Characters:

"," to pause for one second.

NOTE:



EXAMPLE:

? 'Dialing Information: Press Enter to Talk or Hang up'
t = k_Dial('9,,555-1212')

Result: t = <inkey code of key pressed>

******************************************************************************/

#define FLUSHKEYS __KeyBoard("")

#include "klipper.ch"
#include "fileio.ch"
#include "inkey.ch"

FUNCTION k_Dial(cPhoneNum, nComPort)
LOCAL    cPort := ''
LOCAL    nKey := 0
LOCAL    nPortHandle := 0

BEGIN SEQUENCE

if cPhoneNum = NIL
    BREAK
endif

nComPort = iif(nComPort = NIL,1,nComPort)

cPort = 'COM'+alltrim(str(nComPort))

nPortHandle = fopen(cPort,FO_READWRITE)

if ferror() = 0

    altd()

    fwrite(nPortHandle,cPhoneNum+chr(K_ENTER))

    if ferror() != 0
        nKey = -2
        BREAK
    endif

    FLUSHKEYS

    while TRUE
        if ( nKey := inkey() ) != 0
            BREAK
        endif
    end

else
    nKey = -1
    BREAK
endif

END SEQUENCE

if nPortHandle != 0
    fwrite(nPortHandle,'ATH'+chr(K_ENTER))
    fclose(nPortHandle)
endif

RETURN(nKey)

