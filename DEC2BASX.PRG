/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Dec2BaseX( nNum, nBase ) --> cBaseNumString

PARAMETERS:

nNum  : Numeric Decimal value
nBase : Base to convert nNum to

SHORT:

Convert a decimal integer to any other base in the range 1...72.

DESCRIPTION:

k_Dec2BaseX() converts decimal numeric values to any other base in the range 
1 -> 72.

NOTE:

See CAUTIONS under k_BaseX2BaseY()!

EXAMPLE:

#define HEX 16
#define OCT 8
#define BIN 2

t = k_Dec2BaseX(100,BIN)
Result: t = "1100100"

t = k_Dec2BaseX(100,OCT)
Result: t = "144"

t = k_Dec2BaseX(100,HEX)
Result: t = "64"

******************************************************************************/

#define SYMBOLSET "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
FUNCTION k_Dec2BaseX( nNum, nBase )
LOCAL    cRetVal := ''
LOCAL    i

if nBase = 2
    // in the case of dec to bin, this is a much quicker way!

    cRetVal = k_IToBS(nNum)

else

    for i = 1 to 72  // base 72 is highest base I can do with the charset 0...~

        if (nBase**i) <= nNum

            cRetVal = substr(SYMBOLSET,1+int(nNum%nBase**i),1)+cRetVal
            nNum -= (nNum - (nNum/nBase**i))

            if nNum < nBase**1
                cRetVal = substr(SYMBOLSET,nNum+1,1) + cRetVal
                exit
            endif

            i = 0

        else
            cRetVal = substr(SYMBOLSET,nNum+1,1)
            EXIT
        endif

    end

endif

RETURN(cRetVal)

