/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ToPrn( cPrinterCodesFile, lRetryable ) --> lPrinterStatus

PARAMETERS:

cPrinterCodesFile : text file containing printer commands or codes.
lRetryable        : TRUE or not specified (NIL), user can retry.
                    FALSE, user cannot retry.

SHORT:

Set printer on (with optional command codes from file).

DESCRIPTION:

k_ToPrn() simply set's output to printer, eliminating the need for three 
print redirection statements each time. 

Optionally, you may specify a set of printer initialization codes by 
placing them in a text file and specifying that file in cPrinterCodesFile. 
 Each line of the file is sent to the printer "as-is" before 
k_ToPrn() returns.  If not specified, or if invalid file, this option 
is ignored.

If the printer is not on-line (ie, !isprinter()) when the call to k_ToPrn() 
is made, and lRetryable is specified and is FALSE, then the function 
does nothing to the settings of the _SET_PRINT, _SET_DEVICE, and 
_SET_CONSOLE, and immediately returns the status of the printer (FALSE). 

THE PRINT SETTINGS WILL NOT HAVE BEEN AFFECTED!

If, however, the lRetryable is TRUE or NIL, then a dialogue box is 
invoked informing the user that the printer is offline and to turn it on. 

The user is given three attempts at setting the printer on-line before 
the application is terminated with the message:

Printer Error During k_ToPrn()

This is NOT a run-time error, but an intentional shutdown of the application. 
 Consequently, no debug/run-time error data is collected in the errorlog 
file. See k_Terminate() for more information. 

If the printer is properly set on-line within the three allowed attempts, 
then the k_ToPrn() function carries on as if nothing had happened, and 
the settings of PRINT, DEVICE and CONSOLE are set to TRUE, "PRINT", 
FALSE respectively.

NOTE:

See also, HPRINTF(), k_Terminate(), k_LPrint()

EXAMPLE:

k_ToPrn()

Result: Output is directed to the printer, and the user dialogue box 
is invoked of the printer is not on-line.

k_ToPrn('HPITALIC.TXT')

Result: Output is directed to the printer and the printer setup codes 
in HPITALIC.TXT are sent to the printer one line at a time.

The user dialogue box is invoked of the printer is not on-line.

k_ToPrn('HPITALIC.TXT',.F.)

Result: Same as above, but if the printer is not on line, the settings 
of PRINT, DEVICE, and CONSOLE are left unchanged and the function 
returns false.

******************************************************************************/
#include "klipper.ch"

FUNCTION k_ToPrn(cPrinterCodesFile,lRetryable)
LOCAL    acPrintCodes := {}
LOCAL    i

LOCAL    lOldPrintSet
LOCAL    cOldDeviceSet
LOCAL    cOldConsoleSet

lRetryable = iif(lRetryable = NIL, TRUE, lRetryable)

if isprinter()

    set cons off
    set device to print
    set print on

    if cPrinterCodesFile != NIL

        if file(cPrinterCodesFile)

            acPrintCodes = k_TextArray(cPrinterCodesFile)

            for i = 1 to len(acPrintCodes)
                k_LPrint(acPrintCodes[i])
            next

        endif

    endif
else

    i = 0

    while (i++ < 3)

        tone(2000,2)

        lOldPrintSet   := set(_SET_PRINTER,FALSE)
        cOldDeviceSet  := set(_SET_DEVICE,'SCREEN')
        cOldConsoleSet := set(_SET_CONSOLE,TRUE)

        setcolor('w+/r')

        k_TextBrowse(7,5,15,75,LF+'k_ToPrn(): The printer is not responding'+LF+'_____________________________'+LF+LF+;
        '  Please check that the printer has paper loaded and is on-line.',BOXTHICK,LABELBOTTOM,' Press ESC to Retry ')

        set(_SET_PRINTER,lOldPrintSet)
        set(_SET_DEVICE,cOldDeviceSet)
        set(_SET_CONSOLE,cOldConsoleSet)

        if isprinter()
            exit
        endif

    end

    if !isprinter()
        k_Terminate('Printer Error During k_ToPrn()')
    else
        // Have printer now, now "pass along" the original call and parameters
        // which should work flawlessly

        k_ToPrn(cPrinterCodesFile)

    endif


endif

RETURN(isprinter())

