/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_SetUsrPrint( nFRow, nFCol, nTRow, nTCol, cColor ) --> NIL

PARAMETERS:

nFrow  : Printer Selection Box Coordinates
nFCol  : " "
nTRow  : " "
nTCol  : " "
cColor : Selection Box Color

SHORT:

Set printer settings per individual user.

DESCRIPTION:



NOTE:

See _SelUsrPrn() for a complete description.

EXAMPLE:



******************************************************************************/

FUNCTION k_SetUsrPrint(nFRow,nFCol,nTRow,nTCol,cColor)
#include "klipper.ch"
#include "kfile.ch"

LOCAL    OldArea   := Select()
LOCAL    Old_Color := SetColor()
LOCAL    U_Name    := gete("U_NAME")
LOCAL    cScr

MEMVAR   m_Print_Num
MEMVAR   Help_Label

FIELD    User_Name

PRIVATE  Help_Label := 'SetUsrPrint'

nFRow = iif(nFRow = NIL,5 ,nFRow)
nFCol = iif(nFCol = NIL,40,nFCol)
nTRow = iif(nTRow = NIL,12,nTRow)
nTCol = iif(nTCol = NIL,77,nTCol)
cColor = iif(cColor = NIL,SetColor(),cColor)

SetColor(cColor)
cScr = SaveScreen(nFRow,nFCol,nTRow+2,nTCol+2)

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
            FLD CUSTOM_3,   C, 75
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

    // prompt dbchoice to select printer for user: u_name

    k_Box(nFRow,nFCol,nTRow,nTCol)
    @ nFrow+2,nFCol+1 to nFRow+2,nTCol-1 Double
    @ nFrow+1,nFCol+1 say 'P# Name'

    m_Print_Num = k_DBChoice('printdef.dat',,'Print_Num+" "+Print_Name','Print_Num',nFRow+3,nFCol+1,nTRow-1,nTCol-1)

    if m_Print_Num = NIL
        // selected nothing
    else
        if empty(m_Print_Num)
            // selected blank record
        else
            // selected valid printer
            // store to userprin.dat

            k_SUse('userprin.dat','userprin',0)

            LOCATE FOR lower(user_name) = lower(u_name)

            if !found()
                k_NewRec()
            endif

            if k_RLock()

                Replace User_Name WITH u_name, ;
                        Printer   WITH m_Print_Num

            endif

            dbCloseArea()

        endif
    endif

    restscreen(nFRow,nFCol,nTRow+2,nTCol+2,cScr)

endif

dbclosearea() ; Select (OldArea) ; SetColor(Old_Color)

RETURN(NIL)

