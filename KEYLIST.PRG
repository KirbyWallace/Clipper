/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_KeyList( cKeyList, cKeyColor, nKeyLine, cHiLightColor ) --> NIL

PARAMETERS:

cKeyList      : text string to print on the screen
cKeyColor     : color to use
nKeyLine      : Screen Line to print to
cHiLightColor : Color string for hilighting (see DESCRIPTION)

SHORT:

Present a line of text on a given line.

DESCRIPTION:

k_KeyList() is used to print a text string at line MAXROW() in the color 
specified in cKeyColor.  If cKeyColor is not specified, the current color
setting is used.

This function is used primarily in conjunction with k_FScreen(), k_Menu(), and 
k_MenuA() as part of an overall screen management scheme that this library 
supports.

If cHiLightColor is specified, then any text delimited by "" and "" is
highlighted with this color and the delimiters are removed.  "" and ""
are chr(16) and chr(17) respectively.   See EXAMPLE.

NOTE:

EXAMPLE:

k_KeyList('F1 - Help, Esc - Quit')

    Result: "F1 - Help, Esc - Quit" is printed on line MAXROW() of the screen
    in the current color setting.



k_KeyList('F1 - Help, Esc - Quit',"W+/G")

    Result: "F1 - Help, Esc - Quit" is printed on line MAXROW() of the screen
    in a "W+/G" color setting.



k_KeyList('F1 - Help, Esc - Quit',"W+/G", 5 )

    Result: "F1 - Help, Esc - Quit" is printed on line 5 of the screen
    in a "W+/G" color setting.



k_KeyList('F1 - Help, Esc - Quit',"W+/G",,"R+/G" )

    Result:

        "F1 - Help, Esc - Quit"

        is printed on line MAXROW() of the screen in a "W+/G" color setting,
        with "F1" and "Esc" hilighted in R+/G.


******************************************************************************/

FUNCTION k_KeyList( cKeyList, cKeyColor, nKeyLine, cHiLightColor )

LOCAL    cOldColor := setcolor()
LOCAL    nRow      := row()
LOCAL    nCol      := col()

LOCAL    acHiLightText := {}

LOCAL    i

if cKeyColor != NIL
    setcolor(cKeyColor)
endif

if nKeyLine = NIL
    nKeyLine = maxrow()
endif


if cHiLightColor = NIL

    @ nKeyLine,00 CLEAR TO nKeyLine,maxcol()
    @ nKeyLine,00 SAY      cKeyList

else

    while ( at( "", cKeyList ) > 0 )

        aadd( acHiLightText, k_Snatch( cKeyList, at("",cKeyList)+1, at("",cKeyList)-1 ) )

        cKeyList = strtran( cKeyList, "", "", 1,1 )
        cKeyList = strtran( cKeyList, "", "", 1,1 )

    end

    @ nKeyLine,00 CLEAR TO nKeyLine, maxcol()
    @ nKeyLine,00 SAY      cKeyList

    for i = 1 to len(acHiLightText)
        k_HiLight( nKeyLine, acHiLightText[i], cHiLightColor )
    next

endif

setcolor( cOldColor )

devpos( nRow, nCol )

RETURN( NIL )

