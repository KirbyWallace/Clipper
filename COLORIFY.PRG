/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Colorify( nRow, nCol, cString, cBackground )

PARAMETERS:

nRow        :  Window coords where string will be drawn
nCol        :  "                                      "
cString     :  String to be drawn in wild colors
cBackground :  Color for background (ie, "N", or "BG" etc)

SHORT:

Draws a string with every character a different color

DESCRIPTION:

The short says it all

NOTE:

This has gotta be one of the stupidest functions I have ever written.  Seems
like I had a justifiable reason for it at the time though.

EXAMPLE:

k_Colorify( 5, 10, "THIS IS A STWING", "N" )

Result: The multicolored string is drawn on a black background

******************************************************************************/

#include "klipper.ch"

FUNCTION k_Colorify( nRow, nCol, cString, cBackground )

LOCAL    cJunkNums := "81726354871652837451827356481726534862418743678651234"+;
                      "12731487235647812378457812356487651234561234658172635"+;
                      "17235648176527623547652734518721873645817623874651872"+;
                      "18723487651273476253745187265387458172563764576234517"+;
                      "17823564765172563756476517263576458176528476581726347"+;
                      "87236451872635486518723775236476545178263547651872674"+;
                      "65127341872374776515725374572636547158273841723487172"

LOCAL    acColors := { "N","B", "G", "R", "BG", "RB", "GR", "W"  }


LOCAL    cBright := ""

LOCAL    i := 1
STATIC   j := 1

cBackground = iif(cBackground = NIL, "N", cBackground )

for i = 1 to len( cString )

    cBright = iif(  (int((j*i) / i) % 2 = 0) .or. (substr(cJunkNums,j,1) = "1") , "+" , " " )

    @ nRow, nCol+i SAY substr(cString,i,1) COLOR ( acColors[val(substr(cJunkNums,j++,1))] + cBright + "/" + cBackground )

    if j >= len(cJunkNums)
        j=1
    endif

next

RETURN(NIL)

