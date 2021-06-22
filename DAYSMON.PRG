/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_DaysInMonth( nMonth, nYear ) --> nDaysInMonth

PARAMETERS:

nMonth : Month of year to test
nYear  : Year to test

SHORT:

Return the number of days in any given month, accounting for leap years.

DESCRIPTION:

k_DaysInMonth() returns the number of days in a given month, with proper 
respect for leap years.

NOTE:



EXAMPLE:

t = k_DaysInMonth(8,93)
Result: t = 31


t = k_DaysInMonth(2,93)
Result: t = 28


t = k_DaysInMonth(month(ctod('02/01/92')),year(ctod('02/01/92')))
Result: t = 29

******************************************************************************/

FUNCTION k_DaysInMonth( nMonth, nYear )
LOCAL    dNextMonth

if nMonth = 12
    dNextMonth = ctod( "01/01/"+ltrim(str(nYear+1)) )
else
    dNextMonth = ctod( substr(ltrim(str(101+nMonth)),2,2) + "/01/" + ltrim(str(nYear)) )
endif

RETURN(day(dNextMonth-1))

