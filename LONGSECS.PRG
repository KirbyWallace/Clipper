/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_LongSeconds() --> nSeconds

PARAMETERS:

None

SHORT:

Return seconds since 01/01/80, rather than from midnight of current day.

DESCRIPTION:

k_LongSeconds() is similar to Clipper's seconds() function, but returns
the number of seconds since 0000 hours on 01/01/80.  It therefore does 
not reset to ZERO at midnight, but continues to accumulate time constantly.

NOTE:

The time necessary to calculate the _LongSeconds() return value is obviously 
longer than Clipper's simple seconds() function.  The function requires, on 
my 486/33, 1320 repetitions to consume one second, however, since the
calculation is done from scratch each time, the actual time loss  is only
several thousandths of a second (1/1320th of a second in my case), and the
difference deosn't accumulate as time goes on.  The value should never, in
any case, become significant (no more than seconds() itself).


k_LongSeconds() can be abbreviated k_LongSecs()

EXAMPLE:

? _LongSeconds()  // 441889015.23

******************************************************************************/

FUNCTION k_LongSecs()
RETURN((k_DaysBetween(ctod('01/01/80'),date(),1)*86400)+seconds())

FUNCTION k_LongSeconds()
RETURN((k_DaysBetween(ctod('01/01/80'),date(),1)*86400)+seconds())

