/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_LPrint( cPtrData, lCrLf ) --> NIL

PARAMETERS:

cPtrData : Character data to print on printer
lCrLf    : Logical TRUE = issue CRLF pair after data (DEFAULT)
           FALSE = append data to printer current line

SHORT:

Print text directly to the printer.

DESCRIPTION:

k_LPrint() writes the contents of cPtrData to the printer regardless of 
current printer settings, and restores the printer settings to the state they 
were in before the call.

lNoCrLf controls whether or not to append a CRLF pair after the data has been 
printed.  If TRUE, the effect is QOUT()/?, if FALSE, QQOUT()/??.

NOTE:



EXAMPLE:

SET PRINT ON
SET DEVICE TO PRINT
SET CONSOLE OFF

k_LPrint(chr(27)+'E')

Result: ESC-E is written to the printer and the status of SET PRINT, 
SET DEVICE, and SET CONSOLE remain the same when the function returns.

SET PRINT OFF
SET DEVICE TO SCREEN
SET CONSOLE ON

k_LPrint(chr(27)+'E')

Result: Same as above.  String is written to printer regardless of current 
SET PRINT, DEVICE and CONSOLE settings. Original Settings are restored 
after use.

#define LP_APPEND .F.

k_LPrint('ABC')
k_LPrint('DEF')

Result (on printer):
ABC
DEF

k_LPrint('ABC')
k_LPrint('DEF',LP_APPEND)

Result (on printer): ABCDEF

******************************************************************************/

#include "set.ch"
#define ON  .t.
#define OFF .f.

FUNCTION k_LPrint(cPtrData,lCrLf)

LOCAL    printer_set := set(_SET_PRINTER)
LOCAL    wrap_set    := set(_SET_WRAP)
LOCAL    device_set  := set(_SET_DEVICE)
LOCAL    console_set := set(_SET_CONSOLE)

lCrLf = iif(lCrLf = NIL,.f.,lCrLf)

if isprinter()

    set(_SET_PRINTER,ON)
    set(_SET_CONSOLE,OFF)
    set(_SET_DEVICE,'P')

    if lCrLf
        qout(cPtrData)
    else
        qqout(cPtrData)
    endif

endif


set(_SET_PRINTER, printer_set)
set(_SET_WRAP,    wrap_set)
set(_SET_DEVICE,  device_set)
set(_SET_CONSOLE, console_set)

RETURN(NIL)


