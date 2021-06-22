/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_CheckSum( cString, nMode ) --> xRetVal

PARAMETERS:

cString : The string to be checksummed
nMode   : Operation Mode:
            KCRC_GENERATE = Generate checksum string
            KCRC_TEST     = Test checksum string
            KCRC_EXTRACT  = Extract checksum from string

SHORT:

k_CheckSum() is a checksum generation and testing function.

DESCRIPTION:

KCRC_GENERATE MODE  (default mode)
----------------------------------


In mode K_GEN, the string passed in cString is CRC'ed, the checksum digits 
are embedded in the string, and the new string is returned.

KCRC_TEST MODE
--------------

In mode K_TST, the string passed in cString must have been generated 
by k_CheckSum() in K_GEN mode.  The string is tested to see if it's checksum 
is valid.  A checksum is valid when it is ZERO.

KCRC_EXTRACT MODE
-----------------

In KCRC_EXTRACT mode, cString must be a string created with k_CheckSum() 
in KCFC_GENERATE Mode.  The checksum digits that were generated for the 
string are extracted from it and returned as a hexadecimal string.

Usage
----------


The basic "modus operandi" is to generate a CRC'ed string using: 

cStr1 = k_CheckSum(cStr1,KCRC_GENERATE)

Then send it, transmit it, store and retrieve it, etc.

Then to verify that it has not changed during any operation, check it with:

nSameOrDiff = k_CheckSum(cStr1,KCRC_TEST)

nSameOrDiff will be ZERO if the string has not changed any since it 
was CRC'ed, or non-ZERO if it has.

NOTE:

k_CheckSum() returns values of different types depending upon usage mode.

This checksum is a loose interpretation of the Fletcher CRC algorithm.  
Fletcher's CRC, while not a full blown CRC is accurate with strings (blocks) 
up to 255 bytes. You should break your data into chunks of 255 bytes if it 
exceeds this amount, and CRC each block independantly. Theoretically, any 
block size will reliably produce a valid CRC value, *BUT* you should be aware 
of a few things.

Lot's of things will equate to the same checksum.  However, two strings under 
2048 bytes, that are supposed to be the same in the first place, have a very 
very small chance of generating the same checksum.


For instance a string of 63 of any one character and 318 of the same 
character will generate the same checksum.  However, it should be obvious, 
when looking for single bit or byte differences, that a 63 character string 
is not anything like a 318 character string, not matter what character they 
have in common, or how many of them.  LEN() used in conjunction with with the 
CRC should greatly increase security.




EXAMPLE:

cString = "Mary had a little jam, it's beat was white and slow..."

// create the string with checksum digits
cString = k_CheckSum(cString,KCRC_GENERATE) // cString has checksum
// embedded now.


// later, check to see if it is intact (ie, the same)
nCRCResult = k_CheckSum(cString,KCRC_TEST)  // nCRCResult has 0
// if the string is
// unchanged.


// To see what the checksum value actually is:
cCRCDigits = k_CheckSum(cString,KCRC_EXTRACT)


? cCRCDigits  // Result "A61F" - Uhhhh, or something like that.

******************************************************************************/
#include "klipper.ch"

FUNCTION k_CheckSum(cString, nMode)

LOCAL    n1, p1, p2
LOCAL    xRetVal := NIL

nMode = iif(nMode = NIL .or. !(k_InRange(nMode,KCRC_GENERATE,KCRC_EXTRACT)),KCRC_GENERATE,nMode)

do case

    case nMode = KCRC_GENERATE

        n1 = k_cFcrc(cString)

        p1 = int(n1/1000)
        p2 = n1-(int(n1/1000)*1000)

        cString += chr(p1)+chr(p2)

        xRetVal = cString

    case nMode = KCRC_TEST

        n1 = k_cFcrc(substr(cString,1,len(cString)-2))

        p1 = int(n1/1000)
        p2 = n1-(int(n1/1000)*1000)

        xRetVal = iif((chr(p1)+chr(p2) = right(cString,2)),0,1)


    case nMode = KCRC_EXTRACT

        n1 = k_cFcrc(cString)

        p1 = int(n1/1000)
        p2 = n1-(int(n1/1000)*1000)

        xRetVal = padl(k_Dec2BaseX(p1,16),2,'0')+padl(k_Dec2BaseX(p2,16),2,'0')+'h'

endcase

RETURN(xRetVal)

