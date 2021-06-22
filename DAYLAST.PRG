/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_DayLast( dDate ) --> nDay

PARAMETERS:

dDate : Date from which last day of the month is to be derived.

SHORT:

Determine the date of the last day of the month, with respect for leap years.

DESCRIPTION:

k_DayLast() returns the date of the last day of the month of dDate in the same 
way that k_DayFirst( returns the first day of the month.  It also properly 
returns "02/29/yy" on leap years.

NOTE:



EXAMPLE:

t = k_DayLast( ctod('03/22/93') )

    Result: (t == ctod('03/31/93') ) = TRUE

t = k_DayLast( ctod('02/22/93') )

    Result: (t == ctod('02/28/93') ) = TRUE

t = k_DayLast( ctod('02/22/92') )

    Result: (t == ctod('02/29/92') ) = TRUE


******************************************************************************/
FUNCTION k_DayLast( dDate )

RETURN(ctod(ltrim(str(month(dDate)))+'/'+ ;
       ltrim(str(k_DaysInMonth( month(dDate),year(dDate) )))+'/'+ ;
       ltrim(str(year(dDate)))))

