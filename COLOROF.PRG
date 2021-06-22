/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ColorOf( nColor ) --> cColor

PARAMETERS:

nColor: number (1...5) indicating color string to return.

        Use the following Pre-Processor #defines (defined in KLIPPER.CH):

        STANDARD_COLOR   1
        ENHANCED_COLOR   2
        BORDER_COLOR     3
        BACKGROUND_COLOR 4
        UNSELECTED_COLOR 5

SHORT:

k_ColorOf() returns the color pair setting for a given clipper color scheme.

DESCRIPTION:

k_ColorOf() returns the current color setting for a given Clipper color
setting.  For instance, to get the current color setting of Standard
SAYs, use k_ColorOf(STANDARD_COLOR).

There are five to chose from, listed in the preprocessor macros above.

NOTE:

EXAMPLE:

setcolor("W+/N, W+/B, W+/G, W+/R, W+/RB" )

? k_ColorOf( STANDARD_COLOR )       //  Returns: "W+/N"
? k_ColorOf( ENHANCED_COLOR )       //  Returns: "W+/B"
? k_ColorOf( BORDER_COLOR )         //  Returns: "W+/G"
? k_ColorOf( BACKGROUND_COLOR )     //  Returns: "W+/R"
? k_ColorOf( UNSELECTED_COLOR )     //  Returns: "W+/RB"

? k_ColorOf( 23 )                   //  if it returns at all, who knows?
? k_ColorOf( -5 )                   //  USE THE PP MACROS!

******************************************************************************/


#include "set.ch"
#include "klipper.ch"

FUNCTION k_ColorOf( nColor )
RETURN( k_Extract( set(_SET_COLOR) ,",", nColor ) )

