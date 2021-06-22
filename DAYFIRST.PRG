/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_DayFirst( dDate ) --> dFirstDay

PARAMETERS:

dDate : Date from which first day of month is to be derived

SHORT:

Return the DATE of the first day of the month in date passed.

DESCRIPTION:

k_DayFirst() returns the DATE on which the month in dDate began.  If the date 
03/22/93 is passed to the function, it returns 03/01/93.

This is very simple, but it might be useful during leap years since it does 
respect them.

If dDate is NOT a valid date type, _DayFirst returns an empty date.

This is another of those functions that I once had a need for, but forgot 
what it was.  It essentially just returns mm/01/yy for any given date passed. 
 It can be useful when you want to "keep it clean" as in:

dRangeLow = k_DayFirst(date())
dRangeHi  = k_DayLast(date())

This way you do not have to do all the substring manipulation every time you 
want the month begin date of the current (or specified) date.  This is just 
cleaner and easier on the eye.

NOTE:



EXAMPLE:

t = k_DayFirst( ctod('03/22/93') )

Result: (t == ctod('03/01/93') ) = TRUE

******************************************************************************/
FUNCTION k_DayFirst( dDate )
RETURN(iif(valtype(dDate) = 'D',ctod(ltrim(str(month(dDate)))+'/01/'+;
       ltrim(str(year(dDate)))) ,ctod("")))


