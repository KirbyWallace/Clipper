/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Doy( dDate ) --> nDay

PARAMETERS:

dDate : date to derive Day-of-Year

SHORT:

Calculate a "Julian" day of year number from a given date.

DESCRIPTION:

k_Doy() calculates the "day-of-year" for the given date.

If dDate is not specified, the system date is assumed. If dDate is not in 
the current year, then the return value represents the day-of-year for 
the year specified.

dDate can be in the format of mm/dd/yy or mm/dd/yyyy.

NOTE:



EXAMPLE:

t = k_Doy() // assuming sysdate is 03/12/93
Result: t = 71

t = k_Doy(ctod('08/21/93'))
Result: t = 233

******************************************************************************/

FUNCTION k_Doy( dDate )
LOCAL    nRetVal := 0
LOCAL    i


dDate = iif(dDate = NIL, date(), dDate)



for i = 1 to month(dDate)-1
    // determine current days so far
    nRetVal += k_DaysInMonth(i,val(substr(dtoc(dDate),7,2)))

next

nRetVal += day(dDate)


RETURN(nRetVal)



