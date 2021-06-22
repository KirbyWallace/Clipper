/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ScreenScan( nLine, cText, nType, cChar ) --> xRetVal

PARAMETERS:

nLine : Screen Line to scan for text Default is Cursor Line
cText : Text to scan for (Required and CASE SENSITIVE!)
nType : Type of operation to perform
cChar : Delimiter character

SHORT:

Scan screen to locate or extract text.

DESCRIPTION:

k_ScreenScan() operates in one of three ways.  First, it can scan the screen 
and attempt to locate spcified text and return logical TRUE or FALSE 
indicating such.  Second, it can, in lieu of a logical value, return the 
row/col coordinates of the located text in an array.  And thirdly, it can 
extract the text in which the specified token was found.

nType Values:

1 - Scan and Return TRUE if text exists in specified coordinates or FALSE 
otherwise. (DEFAULT)

2 - Scan and Return the row/col coordinates of the located text in an array.

3 - Extract the located text from the specified area, using cChar as 
delimiter.

The Delimiter Character (cChar) is valid only with option 3 from the above. 
The default delimiter is a SPACE.

NOTE:



EXAMPLE:

Line 5 of screen contains:

... "THE FILE NAME IS: S:\POWER\GLORY\FOREVER\AMEN.DAT" ...

Then:

#define K_TORF    1
#define K_POS     2
#define K_EXTRACT 3

k_ScreenScan( 5, '\', K_EXTRACT, ' ')

This usage will return the file name with path from the screen by telling 
the function to look for a backslash and extracting text using SPACE as 
a delimiting char.

BEGIN OR END OF STRING ALWAYS = DELIMIT CHAR

Extract "HOWDY" delimited by SPACE.  All three of the following would 
work just fine:

" HOWDY "   - All three of these are essentially equivelent as
" HOWDY"    - far as extracting the text with a delimiter is
"HOWDY "    - concerned.

In addition to scanning a particular screen line, you can also scan the 
entire screen.  Passing a value of -1 in nLine causes the function to scan 
all lines for the given text  stopping on the first occurance of a match.

In the above example,

k_ScreenScan( -1, 'AMEN.DAT', K_POS)

would return an array with

Element[1] = 5
Element[2] = 42 (or wherever it happens to be)

******************************************************************************/
#include "klipper.ch"

FUNCTION k_ScreenScan( nRow, cText, nType, cChar )

LOCAL    xRetVal
LOCAL    i, j
LOCAL    cLine := ""
LOCAL    cTemp := ""

nRow  = iif(nRow  = NIL, row(), nRow )
nType = iif(nType = NIL, 1,     nType)
cChar = iif(cChar = NIL, " ",   cChar)


// set up default return values for given type operation.

do case

    case nType = K_TORF
        xRetVal = FALSE

    case nType = K_POS
        xRetVal = {-1,-1}

    case nType = K_EXTRACT
        xRetVal = ""

endcase


    for i = (iif(nRow = -1,0,nRow)) to (iif(nRow = -1,maxrow(),nRow))

        cTemp = savescreen(i,0,i,maxcol())

        cLine = ""

        for j = 1 to len(cTemp) STEP 2
            cLine += substr(cTemp,j,1)
        next


        if cText $ cLine

            do case

                case nType = K_TORF

                    xRetVal = TRUE

                    // no need to hang around here!
                    EXIT

                case nType = K_POS

                    xRetVal[1] = i
                    xRetVal[2] = at(cText,cLine)-1

                case nType = K_EXTRACT

                    xRetVal = ""

                    // extract:

                    // back up to first delimiter - copy to next delimiter.


                    j = at(cText,cLine)

                    while (j > 0) .and. (substr(cLine,j,1) != cChar)
                        j--
                    end

                    j++

                    while (j <= len(cLine)) .and. (substr(cLine,j,1) != cChar)

                        xRetval += substr(cLine,j++,1)

                    end

            endcase

        endif

    next

RETURN(xRetVal)

