/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_OR( nData, nKey ) --> nInteger

PARAMETERS:

nData  : Binary Number to OR with nKEY
nKey   : Binary Number to OR with nData

SHORT:

Perform binary OR on two integers.

DESCRIPTION:

k_OR() performs a bitwise OR or two binary numbers. The two numbers are 
padded to the same number of positions (to a maximum of 8 digits) before 
the operation takes place in order to retain positional values:

100101 OR 101    becomes    100101 OR 000101

NOTE:



EXAMPLE:

t = k_OR(1011,11)

original 1011    Both params are padded to eight places 00001011
  Second   11                                           00000011
                                                        --------
    Result:                                             00001011


Result: t = 1011 (leading zeros ignored in RETURN() value)

******************************************************************************/


FUNCTION k_OR(nData,nKey)
LOCAL    cData   := substr(alltrim(str(100000000+nData)),2,8)
LOCAL    cKey    := substr(alltrim(str(100000000+nKey)),2,8)
LOCAL    cBitStr := '', i

for i = 1 to 8

    cBitStr += iif( substr(cData,i,1) .or. substr(cKey,i,1) = '1','1','0')

next

RETURN(val(cBitStr))

