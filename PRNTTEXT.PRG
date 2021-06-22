/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_PrintText( cFileName, nLinesPerPage, nPageNum, cExcludeText ) --> NIL

PARAMETERS:

cFileName     : Text File to Print
nLinesPerPage : Lines per page (Default 55)
nPageNum      : Beginning Page Number
cExcludeText  : Text criteria to Exclude Lines

SHORT:

Print text to printer (no formatting).

DESCRIPTION:

k_PrintText() prints a DOS text file (Source Code, etc).  If the 
nLinesPerPage argument is not supplied, the default is 55 lines per page.  

If the nPageNum argument is supplied, page numbering begins with that 
value, and the internal page number is set to that value also 
(subsequent calls to k_PrintText() will continue with that page number).  

If nPageNum is NOT supplied, the function looks first for it's internal 
page number and if present, uses it. If the nPageNum argument is not 
supplied and there is no internal page number yet established, page 
numbering begins with 1 and 1 becomes the internal page number.

The internal page number is stored in PAGENUM.DAT, thus allowing subsequent 
calls to k_PrintText() to maintain page numbers across multiple files.  To 
reset page numbering, either specify the new beginning page number in 
nPageNum, or deleted the PAGENUM.MEM file.

If cExcludeText is not specified, all lines of text are printed. 

If cExcludeText IS specified, any line in the input file that contains the 
text specified in cExcludeText, is skipped. 

This function makes no printer setting changes.  Any printer settings 
required must be set manually before printing.

k_PrintFile() and k_PrintText() use the same PAGENUM.MEM file and 
can therefore be used together without losing page numbering

NOTE:

k_PrintText() is the generic text printer equivalent of k_PrintFile().

EXAMPLE:

k_PrintText('File1.txt',,1)
k_PrintText('File2.txt')

Result: File1.txt is printed, beginning page numbers at 1, and then 
FILE2.TXT is printed, CONTINUING page numbers from FILE1.TXT (whatever 
that page number may be).

k_PrintText('File1.txt',,1)
k_PrintText('File2.txt',,1)

Result: FILE1.TXT is printed, beginning page numbering at 1, and 
then FILE2.TXT is printed, ALSO beginning page numbering at 1.

******************************************************************************/

#include "fileio.ch"

FUNCTION k_PrintText( cFileName, nLinesPerPage, nPageNum, cExcludeText )
MEMVAR   xx_page
LOCAL    nHandle
LOCAL    cThis_Line
LOCAL    lNewPage := .t.

if nLinesPerPage = NIL
    nLinesPerPage = 55
endif

if cExcludeText = NIL
    cExcludeText = ''
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

    nHandle = fopen(cFileName,FO_READ)

    while !k_FEOF(nHandle)

        if lNewPage
            k_LPrint('File: '+cFileName+space(95)+'Page: '+ltrim(str(XX_Page)))
            k_LPrint(repl(chr(196),127))
            lNewPage = .f.
            XX_Page++
        endif

        cThis_Line = k_ReadLine(nHandle)

        if !empty(cExcludeText)
            if !( lower(cExcludeText) $ lower(cThis_Line) )
                k_LPrint(cThis_Line)
            endif
        else
            k_LPrint(cThis_Line)
        endif


        if prow() > nLinesPerPage
            eject
            lNewPage = .t.
        endif

    end

    eject

    k_ToScr()

    fclose(nHandle)

    SAVE ALL LIKE xx_page* to pagenum.dat

endif

RETURN(NIL)


