/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ItoH( nInteger ) --> cHexString

PARAMETERS:

nInteger: numeric integer value in base 10.

SHORT:

Convert base 10 integer to base 16 hex string.

DESCRIPTION:

k_ItoH() converts a numeric decimal value to it's equivalent hexadecimal 
string representation.

NOTE:

Maximum (known) Integer to Hexadecimal conversion is: 7,686,143,364,045,647.

(That way you can work financial problems involving the U.S. Federal
Budget in Hexadecimal!!!  That's how they do it, I'm sure.)

Beyond that number I am unable to verify accuracy.

EXAMPLE:

? k_ItoH(15)  // returns "F"
? k_ItoH(255) // returns "FF"

******************************************************************************/
FUNCTION k_ItoH(nInteger)
LOCAL    i
LOCAL    j
LOCAL    cHexOut := ""
LOCAL    aHexPosVal := {1,16,256,4096,65536,1048576,16777216,268435456, ;
                        4294967296,68719476736,1099511627776,17592186044416, ;
                        281474976710656,4503599627370496}
LOCAL    cHex := repl('0',len(aHexPosVal))


for i = len(aHexPosVal) to 1 STEP -1

    for j = 16 to 1 STEP -1

        if aHexPosVal[i] * j <= nInteger

            cHex = stuff(cHex,i,1,iif(j > 9, substr('ABCDEF',j-9,1),ltrim(str(j))))
            nInteger -= (aHexPosVal[i] * j)

            exit

        endif

    next

next

for i = len(cHex) to 1 STEP -1
    if substr(cHex,i,1) != '0'
        j = i
        exit
    endif

next

for i = j to 1 STEP -1
    cHexOut += substr(cHex,i,1)
next

return(cHexOut)

