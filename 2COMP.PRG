/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_2Comp( cBinNum ) --> c2CompStr

PARAMETERS:

cBinNum : Character String - Binary Number to 2's complement.

SHORT:

Perform a binary 2's compliment.

DESCRIPTION:

k_2Comp() perfroms a 2's compliment on a binary number.  You will recall that
a 2's compliment is performed by inversing each bit and then adding 1 to the
whole byte.

The cBinNum must be passed as a character string in order to preserve 
significant leading zeros, because:


00101 = 11011 (2's comp) = 27
  101 =   011 (2's comp) =  3

The leading zeros are significant in a 2's compliment.

NOTE:

EXAMPLE:

? k_2Comp('11010101') // '00101011'
? k_2Comp('010101')   //   '101011'

******************************************************************************/
*******************************************************
* The fully optimized, obfuscated and FUN version!!!
*******************************************************
#include "klipper.ch"

FUNCTION k_2Comp( cBinNum )
LOCAL    i := rat("1",cBinNum)
RETURN( strtran(strtran(strtran(substr(cBinNum,1,i-1),"0","X"),"1","0"),"X","1")+substr(cBinNum,i) )

/********************************************************************************************************

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// This is the original.  The "improved" version is exactly same procedure in more
// concise form except that the bit flipping is done more quickly with three sucessive
// strtran()'s than with individual string position in "for i = 1 to len(string)"
/////////////////////////////////////////////////////////////////////////////////////////////////////////

FUNCTION k_2CompOrg(cBinNum)
LOCAL    cBitStr, i, nCarry

for i = 1 to len(cBinNum)
    cBinNum = stuff(cBinNum,i,1,iif(substr(cBinNum,i,1) = '1','0','1'))
next

cBitStr = '' ; nCarry = 1

for i = len(cBinNum) to 1 STEP -1
    if substr(cBinNum,i,1) = '0'
        if nCarry = 1
            cBitStr = '1'+cBitStr
            nCarry = 0
        else
            cBitStr = '0'+cBitStr
            nCarry = 0
        endif
    else
        if nCarry = 1
            cBitStr = '0'+cBitStr
            nCarry = 1
        else
            cBitStr = '1'+cBitStr
            nCarry = 0
        endif
    endif
next

RETURN(cBitStr)

********************************************************************************************************/


/********************************************************************************************************
// This was the "improved" (but not optimized) version.

FUNCTION k_2Comp( cBinNum )

LOCAL    cBitStr := ""
LOCAL    i
LOCAL    nCarry := 1

cBinNum = strtran(cBinNum,"0","X")
cBinNum = strtran(cBinNum,"1","0")
cBinNum = strtran(cBinNum,"X","1")

for i = len(cBinNum) to 1 STEP -1

    if substr(cBinNum,i,1) = "0"
        cBitStr = str(nCarry,1)+cBitStr
        nCarry = 0
    else
        cBitStr = str(abs(nCarry-1),1)+cBitStr
    endif

next

RETURN( cBitStr )


*********************************************************************************************************/



