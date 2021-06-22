/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_BaseX2Dec( cNum, nBase ) --> nDecimalValue

PARAMETERS:

cNum  : number (in base 1 ... 72)
nBase : number indicating base of cNum

SHORT:

Convert any base between 1 and 72 to decimal.

DESCRIPTION:

k_BaseX2Dec() converts a number of any base between 1 and 72 to it's 
numeric decimal equivalent.

See CAUTIONS under k_BaseX2BaseY().

NOTE:



EXAMPLE:

#define HEX  16
#define BIN  2

t = k_BaseX2Dec('F',HEX)
Result: t = 15

t = k_BaseX2Dec('1101',HEX)
Result: t = 4353

t = k_BaseX2Dec('1101',BIN)
Result: t = 13

******************************************************************************/

#define SYMBOLSET "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~"

FUNCTION k_BaseX2Dec( cNumStr, nBase )
LOCAL    nRetVal      := 0
LOCAL    nBaseXPosVal := 1
LOCAL    i

for i = len(cNumStr) to 1 STEP -1
    nRetVal += (at(substr(cNumStr,i,1),SYMBOLSET)-1) * nBaseXPosVal
    nBaseXPosVal *= nBase
next

RETURN(nRetVal)

