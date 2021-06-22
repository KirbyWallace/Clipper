/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Box( nFRow, nFCol, nTRow, nTCol, nBox_Type, nLabel, cLabel_Txt) --> NIL

PARAMETERS:

nFRow      : Screen Coordinates of Box
nFCol      : ""
nTRow      : ""
nTCol      : ""
nBox_Type  : Numeric 1, 2, 3, 4 (See KLIPPER.CH for #defines)
nLabel     : Numeric 1, 4, 5    (See KLIPPER.CH for #defines)
cLabel_Txt : Box Label Text

SHORT:

Draw a box with a "shadow."

DESCRIPTION:

k_Box() draws a box, with shadow.  Optionally, you may specify which type of 
box border you want, and several types of border labels.

The k_Box() function calls k_PopBox() to provide the "exploding" effect, and 
passes the nBox_Type parameter. 

nBox_Type (BOX TYPES):

(Default)
  1         2         3         4           5           6

ฺฤฤฤฤฟ   ึฤฤฤฤฤท   ีอออออธ   ษออออออป    Û฿฿฿฿฿฿฿฿Û     NO BORDER
ณ    ณ   บ     บ   ณ     ณ   บ      บ    Ý        Þ
ณ    ณ   บ     บ   ณ     ณ   บ      บ    Ý        Þ
ภฤฤฤฤู   ำฤฤฤฤฤฝ   ิอออออพ   ศออออออผ    ÛÜÜÜÜÜÜÜÜÛ

NOTE:

The shadow created by k_Box() can be one of two choices.  The shadow can be 
one character wide or two characters wide.  Two characters wide makes the 
shadow area larger and gives the impression that the box is "higher" off the 
desktop area.  This option is not passed as a parameter but is controlled by 
a variable called KBOXHIGH.  To force the Box() "high", create a PUBLIC or 
PRIVATE at the top of your program, or anywhere else so long as it is in 
scope when the k_Box() function is called, and assign it a TRUE value:

PUBLIC KBOXHIGH := .T.

This causes the k_Box() shadow to be two characters wide giving the appearance 
of height.  If this variable is not declared, or is not in scope at the time 
the k_Box() function is called, then the default shadow width is one character 
or "low".

EXAMPLE:

k_Box(5,10,15,70,THICK,LABEL_ARROWS_RIGHT,'This is a label')

Other Label Types (In the following, the ^ and v characters are replaced by 
chr(25) and chr(24) on the screen.  Here they are ^ and v only to satisfy a 
word processor's obsessive/compulsive habit of stripping those characters 
out).  All boxes are of type 4 (BOXDOUBLE):


Example 1           ษออออออออออออออออออออออออออออออออออออออออออออออออออป
Box Type 4          บ                                                  บ
NO LABEL TYPE       บ                                                  บ
                    บ     Label Type NOT SPECIFIED (DEFAULT)           บ
                    บ                                                  บ
                    บ     NO HELP KEY on Bottom AND NO Arrows          บ
                    บ                                                  บ
                    บ                                                  บ
                    ศออออออออออออออออออออออออออออออออออออออออออออออออออผ


Example 2           ษออออออออออออออออออออออออออออออออออออออออออออออออออป
Box Type 4          บ                                                  บ
Label Type 1        บ                                                  บ
                    บ     Label Type 1                                 บ
                    บ                                                  บ
                    บ     Key Help on Bottom no Arrows                 บ
                    บ                                                  บ
                    บ                                                  บ
                    ศอน ^v Move, <พ Select ฬอออออออออออออออออออออออออออผ




Example 3           ษออออออออออออออออออออออออออออออออออออออออออออออออออป
Box Type 4          บ                                                  ^
Label Type 4        บ                                                  บ
                    บ     Label Type 4                                 บ
                    บ                                                  บ
                    บ     Key Help on Bottom AND arrows on RIGHT       บ
                    บ                                                  บ
                    บ                                                  v
                    ศอน ^v Move, <พ Select ฬอออออออออออออออออออออออออออผ




Example 4           ษออออออออออออออออออออออออออออออออออออออออออออออออออป
Box Type 4          ^                                                  บ
Label Type 5        บ                                                  บ
                    บ     Label Type 4                                 บ
                    บ                                                  บ
                    บ     Key Help on Bottom AND arrows on LEFT        บ
                    บ                                                  บ
                    v                                                  บ
                    ศอน ^v Move, <พ Select ฬอออออออออออออออออออออออออออผ


Example using all defaults:

    k_Box(10,10,12,40,4,5)


Result: A box appears on the screen at coordinates: 10,10,12,40 that 
looks similar to Example 4 above, with 
shadow.

Example using all parameters:

    k_Box(5,10,15,70,THICK,LABEL_ARROWS_RIGHT,'This is a label')

Result: A shadow box, at the given coordinates, with a thick (Type 5) border, 
with up and down arrows on the RIGHT side and the label "This is a label" 
on the bottom, is drawn.

******************************************************************************/

#include "klipper.ch"

FUNCTION k_Box(nFRow,nFCol,nTRow,nTCol, nBox_Type, nLabel, cLabel_Txt)

LOCAL    cOldColor
LOCAL    cLabel_str

LOCAL    j
LOCAL    i

MEMVAR   KBOXHIGH

if nBox_Type = NIL
    nBox_Type = 1
else
    if valtype(nBox_Type) != 'N'
        nBox_Type = 1
    else
        * type is numeric, check range, important for autolabel "if" statement
        if nBox_Type < 1 .or. nBox_Type > 6
            nBox_Type = 1
        endif
    endif
endif

if nLabel = NIL
    nLabel = 0
else
    if valtype(nLabel) != 'N'
        nLabel = 0
    else
        if nLabel < 1 .or. nLabel > 5
            nLabel = 0
        endif
    endif
endif

if type('KBOXHIGH') != 'L'
    KBOXHIGH = .f.
endif


cOldColor = SetColor()


k_PopBox(nFRow,nFCol,nTRow,nTCol,nBox_Type)

if (nLabel != 0)

    do case

        case nLabel = LABELBOTTOM // 1 && auto navigation label
            cLabel_str = ' Move, พ Select'

        case nLabel = 2
            cLabel_str = 'UNUSED STR1'

        case nLabel = 3  // 3
            cLabel_str = 'UNUSED STR2'

        case nLabel = LABEL_ARROWS_RIGHT .or. nLabel = LABEL_ARROWS_LEFT   // 4 .or. 5
            * arrows on right side, top and bottom AND navigation
            cLabel_str = ' Move, พ Select'

    endcase

    **********************************************************************************
    * if the label string has been specified by argument, override the default label *
    **********************************************************************************

    if valtype(cLabel_Txt) == 'C'
        cLabel_str = cLabel_Txt
    endif

    **************************************
    * match box type passed in nBox_Type *
    **************************************

    if k_InRange(nBox_Type,1,5)

        if !empty(cLabel_Str)
            do case

            case (nBox_Type = BOXSINGLE .or. nBox_Type = BOXDOUBLESIDE)  // 1 .or. 3
                @ nTRow, nFCol+3 say 'ด '+cLabel_str+' ร'

            case (nBox_Type = BOXDOUBLE .or. nBox_Type = BOXDOUBLETOP)            // 2 .or. 4
                @ nTRow, nFCol+3 say 'ถ '+cLabel_str+' ว'

            case nBox_Type = BOXTHICK
                @ nTRow, nFCol+3 say 'Ý'+cLabel_str+'Þ'

            endcase

        endif

    endif

    if nLabel = LABEL_ARROWS_RIGHT // 4
        @ nFRow+1, nTCol say ''
        @ nTRow-1, nTCol say ''

        if !empty(cLabel_Str)
            if (nBox_Type = BOXSINGLE .or. nBox_Type = BOXDOUBLESIDE)
                @ nTRow, nFCol+3 say 'ด '+cLabel_str+' ร'
            else
                * nBox_Type = BOXDOUBLETOP .or. nBox_Type = BOXDOUBLE
                @ nTRow, nFCol+3 say 'ถ '+cLabel_str+' ว'
            endif
        endif

    else
        if nLabel = LABEL_ARROWS_LEFT // 5
            @ nFRow+1, nFCol say ''
            @ nTRow-1, nFCol say ''

            if !empty(cLabel_Str)
                if (nBox_Type = BOXSINGLE .or. nBox_Type = BOXDOUBLESIDE)  // 1 or 3
                    @ nTRow, nFCol+3 say 'ด '+cLabel_str+' ร'
                else
                    * nBox_Type = BOXDOUBLETOP .or. nBox_Type = BOXDOUBLE
                    @ nTRow, nFCol+3 say 'ถ '+cLabel_str+' ว'
                endif
            endif

        endif
    endif

endif

set color to n+/n

if KBOXHIGH

    // additional column to the right of standard (default) column.  This gives two columns on the right

    restscreen(nFRow+1,nTCol+2,nTRow+1,nTCol+2, ;
               transform(savescreen(nFRow+1,nTCol+2,nTRow+1,nTCol+2),repl(chr(88)+chr(8),(nTRow-nFRow)*(nTCol-nFCol))))

endif

//right
restscreen(nFRow+1,nTCol+1,nTRow+1,nTCol+1, ;
           transform(savescreen(nFRow+1,nTCol+1,nTRow+1,nTCol+1),repl(chr(88)+chr(8),(nTRow-nFRow)*(nTCol-nFCol))))

// below
restscreen(nTRow+1,nFCol+2,nTRow+1,nTCol+1, ;
           transform(savescreen(nTRow+1,nFCol+2,nTRow+1,nTCol+1),repl(chr(88)+chr(8),(nTRow-nFRow)*(nTCol-nFCol))))


SetColor(cOldColor)

RETURN(NIL)

