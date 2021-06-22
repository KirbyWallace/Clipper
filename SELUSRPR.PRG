/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_SelectUsrPrint( cPrintType ) --> NIL

PARAMETERS:

cPrintType: Print Type to set

SHORT:

Set various printer settings for printers defined in PRINTDEF.DAT.

DESCRIPTION:

k_SetUsrPrint() and _SelUsrPrint() are responsible for creating (if necessary) 
and maintaining two databases that store information on printer setup codes, 
and default printers for users.

The first database, PRINTDEF.DAT, contains printers and their respective 
setup codes for various print attributes.  On the first call to either 
k_SetUsrPrint() or _SelUsrPrint(), if the PRINTDEF.DAT database does not 
exist, it is created with three predefined printer drivers: HP LaserJet, 
Epson FX/MX/LQ, and IBM Proprinter II.

Valid Print Settings are:

COMPRESS  : Compress Print
BOLD      : Bold Print
UNDERLINE : Underline Print
RESET     : Reset Print Codes to Default
CUSTOM_1  : Custom
CUSTOM_2  : Custom
CUSTOM_3  : Custom
CUSTOM_4  : Custom

Each printer driver record contains the following fields:

PRINT_NUM  : Printer Number
PRINT_NAME : Printer Name
COMPRESS   : Code for Condensed Print
BOLD       : Code for Bold Print (Double Strike for Dot matrix)
RESET      : Reset Code
CUSTOM_1   : Custom Code Slot 1
CUSTOM_2   :                  2
CUSTOM_3   :                  3
CUSTOM_4   :                  4

The CUSTOM fields can be used to carry printer codes that are specific to the 
particular printer.  I.E., Landscape is only applicable to Laser Printers, 
and Underline is not a part of any normal selectable font on most dot matrix 
printers.  For that reason, these codes can be set in the CUSTOM_X fields and 
selected in the calling application.

For instance, to use LANDSCAPE on the HP LaserJet, request CUSTOM_2.  You 
might want to use the Clipper Preprocessor to make this clear:

#define HP_UNDERLINE 'CUSTOM_2'

_SelUsrPrint(HP_UNDERLINE)

On the first call to either k_SetUsrPrint() or _SelUsrPrint(), if the 
PRINTDEF.DAT file does not exist, it is created with three predefined printer 
drivers.

The Custom Fields available for these are:

HP LaserJet:

Custom_1: Portrait
Custom_2: Landscape
Custom_3: Underline

Epson FX/MX/LQ:

Custom_1: Near Letter Quality
Custom_2: Italics

IBM ProPrinter II / IBM Graphics:

Custom_1: Near Letter Quality

The SECOND database is USERPRIN.DAT.  This database contains only two fields: 

USER_NAME: User Name as set in DOS Environment Variable U_NAME 
PRINTER  : Number of Selected Printer.

The PRINTER number is used to relate each user to their selected printer 
driver.  U_NAME MUST be set as a DOS Environment Variable BEFORE the program 
starts:

SET U_NAME=PKWALLACE

When the k_SetUsrPrint() function is called, a pick-box is presented with the 
three default printer names and any others that have been specifically added. 
The user picks one from the list.

k_SetUsrPrint() then saves the user name (U_NAME) and the printer number in 
the USERPRIN.DAT database.

When _SelUsrPrint() is called, the user name (U_NAME) is located in the 
USERPRIN.DAT database, the printer number is retrieved and used as a select 
into the PRINTDEF.DAT database to retrieve the code for the correct printer.

All Characters AFTER the first SPACE in the printer code fields are ignored 
(allowing comments).  (i.e., "<ESC>E This is a Reset")

NOTE:



EXAMPLE:

k_SetUsrPrint(10,10,15,45,'w+/n')
_SelUsrPrint('COMPRESS')

Result: k_SetUsrPrint() records the printer number of the printer selected 
from the pick list (whatever it is).

_SelUsrPrint() then sets compressed print from the COMPRESS field from 
the record that contains the user number of the printer selected 
by _SelUsrPrint().

******************************************************************************/

FUNCTION k_SelectUsrPrint(cPrintType)
LOCAL    OldArea   := Select()
LOCAL    lPr_Found := .f.
LOCAL    U_Name    := gete("U_NAME")


MEMVAR   m_Print_Num

FIELD    User_Name
FIELD    Print_Num
FIELD    Printer

#include "klipper.ch"
#include "kfile.ch"

// find name and get printer type.  Use printer type to
// control the codes sent to printer to set cPrintType.

// VALID values for cPrintType include:
// 'COMPRESS' 'BOLD'  'UNDERLINE'  'RESET'
// 'CUSTOM_1' 'CUSTOM_2' 'CUSTOM_3' 'CUSTOM_4'

if type('u_name') == 'C'

    FILE_BEGIN USERPRIN.DAT

        FLD USER_NAME, C, 15
        FLD PRINTER,   C,  2

    FILE_END USERPRIN.DAT

    if !file('printdef.dat')
        FILE_BEGIN PRINTDEF.DAT

            FLD PRINT_NUM,  C,  2
            FLD PRINT_NAME, C, 20
            FLD COMPRESS,   C, 35
            FLD BOLD,       C, 35
            FLD UNDERLINE,  C, 35
            FLD RESET,      C, 35
            FLD CUSTOM_1,   C, 75 // put a port/land code in one of these
            FLD CUSTOM_2,   C, 75 // since they do not apply to all printers
            FLD CUSTOM_3,   C, 75 // hplaser underline in custom also.
            FLD CUSTOM_4,   C, 75 // use "//" to add comment at end of data
            FLD CUSTOM_5,   C, 30
            FLD CUSTOM_6,   C, 30
            FLD CUSTOM_7,   C, 30
            FLD CUSTOM_8,   C, 30
            FLD CUSTOM_9,   C, 30
            FLD CUSTOM_10,  C, 30

        FILE_END PRINTDEF.DAT

        k_XUse('printdef.dat','printdef',0)

        k_NewRec()

        REPLACE Print_Num  WITH '01', ;
                Print_Name WITH 'HP LaserJet II/III', ;
                Compress   WITH chr(27)+'(s0t0b16.67H', ;
                Bold       WITH chr(27)+'(s3B', ;
                Reset      WITH chr(27)+'E', ;
                Custom_1   WITH chr(27)+'&l0O // Portrait', ;
                Custom_2   WITH chr(27)+'&l1O // Landscape', ;
                Custom_3   WITH chr(27)+'&d0D // Underline'

        k_NewRec()

        REPLACE Print_Num  WITH '02', ;
                Print_Name WITH 'Epson MX/FX/LQ', ;
                Compress   WITH chr(15), ;
                Bold       WITH chr(27)+chr(69), ;
                Reset      WITH chr(27)+'@', ;
                Custom_1   WITH chr(27)+chr(120)+'1 // Near Letter Quality', ;
                Custom_2   WITH chr(27)+chr(52)+' // Italics'

        k_NewRec()

        REPLACE Print_Num  WITH '03', ;
                Print_Name WITH 'IBM Proprinter II', ;
                Compress   WITH chr(27)+chr(14), ;
                Bold       WITH chr(27)+chr(69), ;
                Reset      WITH chr(27)+'@', ;
                Custom_1   WITH chr(27)+chr(71)+' // Near Letter Quality'


        dbCloseArea()


    endif

    k_SUse('userprin.dat','userprin',0)

    LOCATE FOR alltrim(lower(user_name)) = alltrim(lower(u_name))

    if found()
        m_Print_Num := Printer
        dbCloseArea()

        k_SUse('printdef.dat','printdef',0)
        LOCATE FOR Print_Num = m_Print_Num

        if found()

            // removed - can't stack commands if you reset before each one

            //if !empty(FIELD->RESET)
            //    k_LPrint(k_SubUntil('~'+FIELD->RESET,'~',' '))
            //endif

            k_LPrint(k_SubUntil('~'+FIELD->&cPrintType,'~',' '))

        endif

    endif

endif

dbclosearea() ; Select (OldArea)

RETURN(NIL)

