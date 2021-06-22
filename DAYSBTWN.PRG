/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_DaysBetween( xDate1, xDate2, nExcludeDays ) --> nDays

PARAMETERS:

dDate1       : Date of first day
dDate2       : Date of second day
nExcludeDays : Number of days to exclude. (DEFAULT: ZERO)

SHORT:

Determine days between dates.

DESCRIPTION:

k_DaysBetween() returns the number of days between two dates, optionally 
including or excluding the days of the parameter dates themselves and 
properly accounting for leap years.

The type of the dates may be either date or character. If character, then the 
format of the date must be: "MM/DD/YY"  Thus, it is not necessary to convert 
character string dates to dates (ala ctod()) before using the function.

nExcludeDays is simply subtracted from the return value to exclude either, or 
both of the two dates from the result.  Therefore, it may be only 0, 1 or 2. 
Any other value will cause the default value of ZERO to be used instead.

nExcludeDays may be 1 to exclude  either the start date or the end date (ie, 
number of days but NOT including the start date or the end date), or 2 to get 
only the number of days in between but not including the parameter dates (ie, 
the number of days between the dates but not including the dates themselves).

NOTE:

If you opt to exclude both the start and the end date (nExcludeDays = 2) 
and then test the same two dates, the result will be ZERO, not -2.  Any 
time that nExcludeDays causes the result to be negative, the result will 
be set to ZERO.

The order of the dates is not important.  k_DaysBetween('08/01/93','08/15/93') 
will work just as well as k_DaysBetween('08/15/93','08/01/93').

EXAMPLE:

? k_DaysBetween('08/01/93','08/15/93')       // 15

|-----------------------------------------|
X  X  X  X  X  X  X  X  X  X  X  X  X  X  X

08/01/93                           08/15/93




? k_DaysBetween('08/01/93','08/15/93',1)     // 14

Excluding either day (begin date or end)

   |--------------------------------------|
|--------------------------------------|
X  X  X  X  X  X  X  X  X  X  X  X  X  X  X

08/01/93                           08/15/93




? k_DaysBetween('08/01/93','08/15/93',2)     // 13

Excluding both begin and end date:


   |-----------------------------------|
X  X  X  X  X  X  X  X  X  X  X  X  X  X  X


08/01/93                           08/15/93


Other examples:

? k_DaysBetween('08/01/93','08/01/93')      // Result: 1
? k_DaysBetween('08/01/93','08/01/93',0)    // Result: 1
? k_DaysBetween('08/01/93','08/01/93',1)    // Result: 0
? k_DaysBetween('08/01/93','08/01/93',2)    // Result: 0

******************************************************************************/

FUNCTION k_DaysBetween( dDate1, dDate2, nExcludeDays )
LOCAL    nDays := 0

if valtype(dDate1) = 'C'
    dDate1 = ctod(dDate1)
endif

if valtype(dDate2) = 'C'
    dDate2 = ctod(dDate2)
endif

if nExcludeDays = NIL
    nExcludeDays = 0
elseif ((nExcludeDays > 2) .or. (nExcludeDays < 0))
    nExcludeDays = 0
endif

if dDate1 > dDate2
    nDays = (dDate1-dDate2)+1

elseif dDate1 < dDate2
    nDays = (dDate2-dDate1)+1

else
    nDays = 1

endif

RETURN(max(nDays-nExcludeDays,0))


