/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_AND( nBinNum1, nBinNum2 ) --> nInteger

PARAMETERS:

nBinNum1 : Binary Number to AND with nBinNum2
nBinNum2 : Binary Number to AND with nBinNum1

SHORT:

Perform Binary AND operation.

DESCRIPTION:

k_AND() performs a bitwise AND on two binary numbers. The two numbers 
are padded to the same number of positions (to a maximum of 8 digits) 
before the operation takes place in order to retain positional values:

100101 AND 101    becomes    100101 AND 000101

NOTE:



EXAMPLE:

t = k_AND(1011,11)

original 1011    Both params are padded to eight places 00001010
Second     11                                           00000011
                                                        --------
Result:                                                 00000010

Result: t = 10 (leading zeros ignored in RETURN())

******************************************************************************/

FUNCTION k_AND(nData1,nData2)
LOCAL cData1  := substr(alltrim(str(100000000+nData1)),2,8)
LOCAL cData2  := substr(alltrim(str(100000000+nData2)),2,8)
LOCAL cBitStr := '', i

for i = 1 to 8

    cBitStr += iif( substr(cData1,i,1) = '1' .and. substr(cData2,i,1) = '1','1','0')

next

RETURN(val(cBitStr))

