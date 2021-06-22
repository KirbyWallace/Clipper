/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_AntiLog(nLog, nBase) --> nAntiLog

PARAMETERS:

nLog  : The logarithm to derive the antilog from
nBase : The base of the logarithm (DEFAULT: 10 - Common Logarithm)

SHORT:

Calculate the Antilogarithm of a number.

DESCRIPTION:

k_AntiLog() returns the antilog of the given logarithm.

NOTE:



EXAMPLE:

If the log of a number is x, then the antilog is the base raised to the power 
of it's log (Base ^ x = antilog).  This is the reverse of the logarithm.

_Log(764.52)    // base 10 log = 2.88

k_AntiLog(2.88)  // base 10 antilog = 764.52

******************************************************************************/

FUNCTION k_AntiLog(nLog, nBase)

if nBase = NIL
    nBase = 10
endif

RETURN(nBase^nLog)

