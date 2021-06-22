/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_XORS( cData, cKey ) --> cStringInt

PARAMETERS:

cData  : Binary Number to XOR with cKEY
cKey   : Binary Number to XOR with cData

SHORT:

Perform a binary Exclusive OR with binary STRINGS.

DESCRIPTION:

k_XORS() performs a bitwise XOR or two binary numbers in STRING format.

The two numbers are padded to the same number of positions (The length of 
the larger number) before the operation takes place in order to 
retain positional values:

100101 XORS 101    becomes    100101 XORS 000101

NOTE:



EXAMPLE:

t = k_XORS('1011','11')

original '1011'   Both params are padded to eight places 1010
key      '11'                                            0011
                                                         ----
                                           Result:       1001

Result: t = "1001"

******************************************************************************/

FUNCTION k_XORS(cData,cKey)
LOCAL    cBitStr := ''
LOCAL    nMaxLen
LOCAL    i

cData = alltrim(cData)
cKey = alltrim(cKey)

nMaxLen := max(len(cData),len(cKey))


cData = repl('0',nMaxLen)+cData ; cData = right(cData,nMaxLen)
cKey  = repl('0',nMaxLen)+cKey  ; cKey  = right(cKey,nMaxLen)


for i = 1 to nMaxLen

    cBitStr += iif( substr(cData,i,1) != substr(cKey,i,1),'1','0')

next

RETURN(cBitStr)

