/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Logr(nNumber, nBase) --> nLog

PARAMETERS:

nNumber : number for which to derive logorithm
nBase   : Log base (DEFAULT: Common Logarithm (Base 10))

SHORT:

Solve for any base log (not just the common log as Clipper's Log() does).

DESCRIPTION:

k_Logr() is a logarithm function that solves for more than just the Common 
Log.  Any base can be specified.

k_Logr() determines the logarithm of the given number in the given log base. 
 If nBase is not specified, _Log() calculates the Common Logarithm of 
the given number (base 10).

The accuracy is calculated far beyond most calculator's 8 decimal places, 
and greater than the accuracy obtained by using the natural log 
(Clipper's LOG()) multiplied by .4343.  Checking for peak accuracy at 
8 decimal places is really more time consuming than simply letting the 
thing calculate the remaining digits.  You get the added precision to boot.

k_Logr() will handle fractional logs (ie, k_Logr(.00613))

Clipper's LOG() function returns the Natural Log of a number not it's 
Common Log.  For base 10 logs, you can quickly calculate the Common Log of 
any number by multiplying the Natural Log by .4343, however k_Logr() will 
yield greater accuracy.

If you need the Natural Logarithm, use Clipper's LOG() function. If you need 
the Common Log, it is probably quicker to use the Clipper (log()*.4343).  If 
you have logs with variable bases, this is the one.


The results from k_Logr(n,10) can be converted to natural log by multiplying 
by 2.3026.

NOTE:

Do not confuse the Common Log with the Natural Log.

DISCUSSION: For those of you new to logarithms:

Logs are strange.  You are asked to find the question for a given answer. 
Not unlike playing Jeopardy!  In a Log, the givens are: The base of the log 
(n - which if not specified is 10 [or the common logarithm] by default) 
which will be used as the number being raised to some power.

If Log(10) x, then the equation is going to contain 10 ^(some power)

Exactly WHAT power is dependant on the given number (x).  This second given 
is the number that is the end result of raising the base of the log (n) to 
the "some power".  So what we are solving for is "what power?" 

Stated: Solve for the exponent of the base of the log that results in 
the given number.

Simple, right?

Stated again:  The base (n) of the log raised to what power equals the 
given number (x)?

EXAMPLE:

? k_Logr(256)    // 2.408239965
? k_Logr(256,10) // 2.408239965
? k_Logr(256,2)  // 8.000000000
? k_Logr(256,5)  // 3.445412465
? k_Logr(256,9)  // 2.523719014

In the above examples, higher precision can be displayed by using a picture 
of some sort:

TRANSFORM(k_Logr(256),'99.999999999999')

******************************************************************************/
#include "klipper.ch"
FUNCTION k_Logr( nNumber, nBase )
LOCAL    nLog := 0
LOCAL    nExp := 0
LOCAL    nLast

LOCAL    nHigh := 1, nLow := 0

BEGIN SEQUENCE

    // Set Default
    if nBase == NIL
        nBase = 10
    endif

    // Handle Error cases
    if nBase == 0
        nExp = NIL
        BREAK
    endif

    if nBase == 1
        nExp = 1
        BREAK
    endif

    if nNumber <= 0
        nExp = NIL
        BREAK
    endif

    // end error cases

    if nNumber >= 1
        nExp = 10
    else
        nExp = -10
    endif

    while TRUE

        nLast = nLog

        nLog = nBase^nExp

        if nLog = nLast
            exit
        endif

        if nNumber >= 1
            if nLog > nNumber
                nHigh = nExp
                nExp -= ((nHigh-nLow)/2)
            elseif nLog < nNumber
                nLow = nExp
                nExp += ((nHigh-nLow)/2)
            endif
        else
            if nLog < nNumber
                nHigh = nExp
                nExp -= ((nHigh-nLow)/2)
            elseif nLog > nNumber
                nLow = nExp
                nExp += ((nHigh-nLow)/2)
            endif

        endif

    end

END SEQUENCE

RETURN(nExp)

