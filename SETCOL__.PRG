/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_SetColor( nColorArea, cNewColor ) --> cOldSetting

PARAMETERS:

PARAMETERS: nColorArea    : Color Area
cNewColor : New Color Setting Value

SHORT:

Set individual color settings without affecting others in the 
scheme.

DESCRIPTION:

DESCRIPTION: k_SetColor() works identically to Clipper's SETCOLOR() 
function with the singular exception that it works on individual color 
"areas" independently from the rest.  That is, you can set the 
Standard, Enhanced, and Unselected foreground and background colors 
without affecting or needing to know the settings of the others.

If cNewColor is not specified, the function simply returns the current 
area color setting.

The individual color areas are selected by the following numerical orders:

1    Standard Foreground Color
2    Standard Background Color

3    Enhanced Foreground Color
4    Enhanced Background Color

5    Unselected Foreground Color
6    Unselected Background Color

Use the following #define statements in your application for clarity:

#define STANDARD_FORE  1
#define STANDARD_BACK  2
#define ENHANCED_FORE  3
#define ENHANCED_BACK  4
#define UNSELECT_FORE  5
#define UNSELECT_BACK  6

cNewColor valid values are:

n     BLACK
b     BLUE
g     GREEN
bg    CYAN
r     RED
rb    NAGENTA
gr    BROWN / YELLOW
w     WHITE
u     UNDERLINE           (MONO)
i     INVERSE             (MONO)
x     BLANK (NON-DISPLAY) (MONO)

k_SetColor() can, for example, alter the standard foreground color without 
changing or needing to know the standard background color.

NOTE:

Background and Border settings are not supported.  On some VGA cards and 
monitors, the BACKGROUND color, which is supposedly not supported by Clipper, 
actually sets the color of a small border. In any case, it is not supported 
by Klipper's k_SetColor().

EXAMPLE:

SET COLOR TO w+/b,g+/n

t = k_SetColor(STANDARD_FORE,'w+*')

Result: The standard foreground color is changed to high-white-blinking, 
the other color settings remain unchanged, and the function returns "W+"

t = k_SetColor(ENHANCED_BACK,'b')

Result: The enhanced background color is changed to blue, the other 
color settings remain unchanged, and the function returns "N"

t = k_SetColor(UNSELECT_BACK)

Result: The unselected background color is left unchanged and and the 
function returns "N"





******************************************************************************/
#include "klipper.ch"
FUNCTION k_SetColor( nColorArea, cNewColor )
LOCAL    cOldSetting  := ''
LOCAL    cOldColor    := setcolor()
LOCAL    cSpacedColor := ''

// pad out the current color string for easy extraction/replacement

cSpacedColor += padr(k_Extract(k_Extract(cOldColor,',',1),'/',1),4,' ')+'/'+padr(k_Extract(k_Extract(cOldColor,',',1),'/',2),4,' ')+','
cSpacedColor += padr(k_Extract(k_Extract(cOldColor,',',2),'/',1),4,' ')+'/'+padr(k_Extract(k_Extract(cOldColor,',',2),'/',2),4,' ')+','
cSpacedColor += 'N   /N   ' +','
cSpacedColor += 'N   /N   ' +','
cSpacedColor += padr(k_Extract(k_Extract(cOldColor,',',5),'/',1),4,' ')+'/'+padr(k_Extract(k_Extract(cOldColor,',',5),'/',2),4,' ')

// pad out cNewColor to five places to make stuff() replace possible
cNewColor = substr(alltrim(cNewColor)+space(4),1,4)

// grab the old color area setting

do case

    case nColorArea = STANDARD_FORE
        cOldSetting = k_Extract(k_Extract(cOldColor,',',1),'/',1)

    case nColorArea = STANDARD_BACK
        cOldSetting = k_Extract(k_Extract(cOldColor,',',1),'/',2)

    case nColorArea = ENHANCED_FORE
        cOldSetting = k_Extract(k_Extract(cOldColor,',',2),'/',1)

    case nColorArea = ENHANCED_BACK
        cOldSetting = k_Extract(k_Extract(cOldColor,',',2),'/',2)

    case nColorArea = UNSELECT_FORE
        cOldSetting = k_Extract(k_Extract(cOldColor,',',5),'/',1)

    case nColorArea = UNSELECT_BACK
        cOldSetting = k_Extract(k_Extract(cOldColor,',',5),'/',2)

endcase


if cNewColor != NIL

    do case

        case nColorArea = STANDARD_FORE
            cSpacedColor = stuff(cSpacedColor,1,4,cNewColor)

        case nColorArea = STANDARD_BACK
            cSpacedColor = stuff(cSpacedColor,6,4,cNewColor)

        case nColorArea = ENHANCED_FORE
            cSpacedColor = stuff(cSpacedColor,11,4,cNewColor)

        case nColorArea = ENHANCED_BACK
            cSpacedColor = stuff(cSpacedColor,16,4,cNewColor)

        case nColorArea = UNSELECT_FORE
            cSpacedColor = stuff(cSpacedColor,41,4,cNewColor)

        case nColorArea = UNSELECT_BACK
            cSpacedColor = stuff(cSpacedColor,46,4,cNewColor)

    endcase

endif

SetColor(cSpacedColor)

RETURN(cOldSetting)

