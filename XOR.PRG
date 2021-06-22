/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_XOR( nData, nKey ) --> nInteger

PARAMETERS:

nData  : Binary Number to XOR with nKEY
nKey   : Binary Number to XOR with nData

SHORT:

Perform a binary Exclusive OR with binary INTEGERS.

DESCRIPTION:

k_XOR() performs a bitwise XOR or two binary numbers. The two numbers 
are padded to the same number of positions (to a maximum of 8 digits) 
before the operation takes place in order to retain positional values:

100101 XOR 101    becomes    100101 XOR 000101

NOTE:



EXAMPLE:

t = k_XOR(1011,11)

original 1011    Both params are padded to eight places 00001010
key      11                                             00000011
                                                        --------
                                          Result:       00001001


Result: t = 1001 (leading zeros ignored in RETURN())

******************************************************************************/

FUNCTION k_XOR(nData,nKey)
LOCAL    cData   := substr(alltrim(str(100000000+nData)),2,8)
LOCAL    cKey    := substr(alltrim(str(100000000+nKey)),2,8)
LOCAL    cBitStr := ''
LOCAL    i

for i = 1 to 8

    cBitStr += iif( substr(cData,i,1) != substr(cKey,i,1),'1','0')

next

RETURN(val(cBitStr))

