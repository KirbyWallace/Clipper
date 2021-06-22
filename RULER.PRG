/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION: k_Ruler( nWholeUnit, nGradient, cNotch, cSub, cWhole, nLength )

PARAMETERS:

nWholeUnit : Number of character positions in each unit
nGradient  : number of divisions (equal parts) of the whole unit
cNotch     : Char to use for each character mark in the scale
cSub       : Char to use for each subdivision mark
cWhole     : Char to use for each unit division mark
nLength    : number of units to extend ruler to

SHORT:

Draw a ruler with varying length, gradient, and scale.

DESCRIPTION:

k_Ruler() draws creates ruler strings.  Consider this ruler:

         10        20        30        40        50        60        70
....|....|....|....|....|....|....|....|....|....|....|....|....|....|


The length is 7 Units

The whole Unit Value is 10

---------| Whole Unit (10)

The Gradient is 2

----|----| Gradient (2) [that is there are 2 * 5 chars divisions of the
                         unit value]

cNotch, cHalf, and cWhole are the characters used on the ruler scale.  The
notch is put on every position unless it is a half dividor of the whole unit.

In Our case, the verticle bar "|" is used for both the half and the whole
notch character.


nWholeUnit: The number of notches that comprise a complete unit. For
            instance if the desired gradient is quarter inches, then
            the nWholeUnit value will be 4, indicating that there are
            4 equal parts to the whole unit.


nGradient:  The gradient of the whole unit value - that is, how many
            equal parts the whole unit value should be divided into.

            The Gradient value must evenly divide the whole unit value
            or you will not get proper subdivision of the unit's range.


            WholeUnit = 20
            Gradient = 4

            Each division will be five characters in length, the four of
            them will comprise the entire Whole Unit length.


            |-----WholeUnit----|

            |Gr | Gr | Gr | Gr |

            ....|....|....|....İ


            But how about this one?

            WholeUnit = 20
            Gradient = 7

            To divide the 20 character unit into 7 equal parts will require
            ALMOST three characters for each portion of the whole.  But you
            cannot have ALMOST three characters.



nLength: The number of units, as defined, with which to create the ruler.
         In our case here, the nWholeUnit value is 10, and the nLength is
         7 (seven times ten whole units = 70).

NOTE:

k_Ruler() returns a string with an embeded ";" indicating where the first
half of the ruler (the scale) ends and the second half (The ruler) begins.
Use substr() to break it apart or strtran() to display by substituting a
CRLF for the semi-colon.


EXAMPLE:

? strtran(k_Ruler( 10, 4, ".", "", "|", 6),";",LF)
"        10        20        30        40        50        60"
"........|........|........|........|........|........|"



? strtran(k_Ruler( 8,  4, "ú", "", "|", 8),";",LF)
"       8      16      24      32      40      48      56      64"
"úúúú|úúúú|úúúú|úúúú|úúúú|úúúú|úúúú|úúúú|"



? strtran(k_Ruler( 12, 4, ".", "", "³", 6),";",LF)
"          12          24          36          48          60          72"
"........³........³........³........³........³........³"



? strtran(k_Ruler( 9,  4, ".", "|", "İ", 6),";",LF)
"        9       18       27       36       45       54"
"........İ........İ........İ........İ........İ........İ"

Note how the above example asks for an impossible even division, resulting
in no subdivision markers.  The next example corrects this.


? strtran(k_Ruler( 9,  3, ".", ":", "|", 6),";",LF)
"        9       18       27       36       45       54"
"..:..:..|..:..:..|..:..:..|..:..:..|..:..:..|..:..:..|"



? strtran(k_Ruler( 10,  2, "Ä", "Â", "³", 6),";",LF)
"        10        20        30        40        50        60"
"ÄÄÄÄÂÄÄÄÄ³ÄÄÄÄÂÄÄÄÄ³ÄÄÄÄÂÄÄÄÄ³ÄÄÄÄÂÄÄÄÄ³ÄÄÄÄÂÄÄÄÄ³ÄÄÄÄÂÄÄÄÄ³"



? strtran(k_Ruler( 10,  5, "Ä", "Â", "³", 6),";",LF)
"        10        20        30        40        50        60"
"ÄÂÄÂÄÂÄÂÄ³ÄÂÄÂÄÂÄÂÄ³ÄÂÄÂÄÂÄÂÄ³ÄÂÄÂÄÂÄÂÄ³ÄÂÄÂÄÂÄÂÄ³ÄÂÄÂÄÂÄÂÄ³"

******************************************************************************/
#include "klipper.ch"

FUNCTION k_Ruler( nWholeUnit, nGradient, cNotch, cSub, cWhole, nLength )

LOCAL    i        AS TYPE_INTEGER
LOCAL    cRuler1  AS TYPE_STRING
LOCAL    cRuler2  AS TYPE_STRING

nLength = iif( nLength = NIL, 80,  nLength )
cNotch  = iif( cNotch  = NIL, ".", cNotch  )
cSub    = iif( cSub    = NIL, "|", cSub    )
cWhole  = iif( cWhole  = NIL, "|", cWhole  )

cRuler1 = repl( " ", (nWholeUnit*nLength) )
cRuler2 = cRuler1

for i = 1 to len(cRuler2)

    cRuler2 = stuff( cRuler2, i, 1, cNotch )

    if i%(nWholeUnit/nGradient) = 0
        cRuler2 = stuff( cRuler2, i, 1, cSub )
    endif

    if i%(nWholeUnit) = 0
        cRuler1 = stuff( cRuler1, i-2, 3, padl(ltrim(str(i)),3," ") )
        cRuler2 = stuff( cRuler2, i,   1, cWhole )
    endif


next

cRuler1 += (";"+cRuler2)

RETURN( cRuler1 )


