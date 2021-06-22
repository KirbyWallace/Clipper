/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_PrintFile(cFileName,nLinesPerPage,nPageNum,cExcludeText,lPageNum,lDate,lLin
eNums) --> NIL

PARAMETERS:

cFileName     : Text File to Print
nLinesPerPage : Lines per page (Default 66)
nPageNum      : Beginning Page Number
cExcludeText  : Text criteria to Exclude Lines
lPageNum      : Logical - print page numbers if TRUE
lDate         : Logical - print date on page header if TRUE
lLineNums     : Logical - Print Line numbers if TRUE

SHORT:

Print text to printer (HP LaserJet formatting).

DESCRIPTION:

k_PrintFile() prints a DOS text file (Source Code, etc) on an HP Laser 
Jet specifically.

If the nLinesPerPage argument is not supplied, the default is 55 lines 
per page.

If lDate is not specified, the default is TRUE (print date). 

If the nPageNum argument is supplied, page numbering begins with that 
value, and the internal page number is set to that value also 
(subsequent calls to k_PrintFile() will continue with that page number).

If nPageNum is NOT supplied, the function looks first for it's internal 
page number and if present, uses it.  If the nPageNum argument is not 
supplied and there is no internal page number yet established, page 
numbering begins with 1 and 1 becomes the internal page number.

The internal page number is stored in PAGENUM.MEM, thus allowing 
subsequent calls to k_PrintFile() to maintain page numbers across 
multiple files.  To reset page numbering, either specify the new 
beginning page number in nPageNum, or deleted the PAGENUM.MEM file.

If cExcludeText is not specified, all lines of text are printed.

If cExcludeText IS specified, any line in the input file that contains 
the text specified in cExcludeText, is skipped. 

This function is expicitly designed to work with the HP LaserJet II/III 
and the font is set to:

    CPI        : 16.67  (Condensed)
    LPI        : 6
    Point Size : 8.5
    Style      : Upright
    Stroke     : Medium
    Typeface   : Line Printer
    Orient     : Port
    Left Margin: 5

These settings can collectively be refered to as Internal Font I001 on the 
HP LaserJet III.

For a Generic Printer see: PRNTTEXT.PRG: k_PrintText()

k_PrintFile() makes no check on the printer status  output is set to print 
and the first line is written.  The programmer must make sure there is 
a printer available before calling k_PrintFile().

NOTE:



EXAMPLE:

k_PrintFile('File1.txt',,1)
k_PrintFile('File2.txt')

Result: File1.txt is printed, beginning page numbers at 1, and then 
FILE2.TXT is printed, CONTINUING page numbers from FILE1.TXT (whatever 
that page number may be).

k_PrintFile('File1.txt',,1)
k_PrintFile('File2.txt',,1)

Result: FILE1.TXT is printed, beginning page numbering at 1, and then 
FILE2.TXT is printed, ALSO beginning page numbering at 1.

******************************************************************************/

#include "klipper.ch"
#include "fileio.ch"

#define  SENDLF TRUE

FUNCTION k_PrintFile( cFileName, nLinesPerPage, nPageNum, cExcludeText, lPageNum, lDate, lLineNums )
MEMVAR   xx_page
LOCAL    nHandle
LOCAL    cThis_Line
LOCAL    lNewPage := TRUE
LOCAL    nLineCounter := 0

if nLinesPerPage = NIL
    nLinesPerPage = 66
endif

if cExcludeText = NIL
    cExcludeText = ''
endif

if lDate = NIL
    lDate = TRUE
endif

if lPageNum = NIL
    lPageNum = FALSE
endif

if lLineNums = NIL
    lLineNums = FALSE
endif

if file(cFileName)

    if nPageNum = NIL

        if file('pagenum.dat')
            restore from pagenum.dat additive
        else
            XX_Page = 1
            save all like xx_page* to pagenum.dat
        endif

    else
        XX_Page = nPageNum
        save all like xx_page* to pagenum.dat
    endif

    k_ToPrn()


    k_LPrint(chr(27)+'&l1S')                                 // set duplex if printer supports it
    k_LPrint(chr(27)+'(10U'+chr(27)+'(s0p16.67h8.5v0s0b0T')  // set compress print

    k_LPrint(chr(27)+iif(lLineNums,'&a0L','&a5L'))           // left margin: 0/5  Line Nums/No line nums

    k_LPrint(chr(27)+'&l8D')                                 // lines per inch select: 8

    nHandle = fopen(cFileName,FO_READ)

    while !k_FEOF(nHandle)

        if lNewPage
            k_LPrint('File: '+cFileName+iif(lDate,'  '+dtoc(date())+space(85),space(95))+iif(lPageNum,'Page: '+ltrim(str(XX_Page)),''),SENDLF)
            k_LPrint(repl(chr(196),127),SENDLF)
            lNewPage = FALSE
            XX_Page++
        endif

        cThis_Line = k_ReadLine(nHandle)

        if !empty(cExcludeText)
            if !( lower(cExcludeText) $ lower(cThis_Line) )

                if lLineNums
                    k_LPrint(transform(++nLineCounter,"99999  "),SENDLF)
                    k_LPrint(cThis_Line)
                else
                    k_LPrint(cThis_Line,SENDLF)
                endif


            endif
        else

            if lLineNums
                k_LPrint(transform(++nLineCounter,"99999  "),SENDLF)
                k_LPrint(cThis_Line)
            else
                k_LPrint(cThis_Line,SENDLF)
            endif


        endif


        if prow() > nLinesPerPage
            eject
            lNewPage = TRUE
        endif

    end

    k_LPrint(chr(27)+'E')

    k_ToScr()

    fclose(nHandle)

    SAVE ALL LIKE xx_page* to pagenum.dat

endif

RETURN(NIL)

