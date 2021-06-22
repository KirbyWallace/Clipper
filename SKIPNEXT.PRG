/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Skip2Next( cField ) --> lIsEOF()

PARAMETERS:

cField : The NAME of a field to skip until value changes

SHORT:

Skip to the next index key value in a database.

DESCRIPTION:

k_Skip2Next() is very simple, but also very time saving.  It looks at the 
field NAMED in the cField parameter and makes note of it's value.  It 
then SKIPS records until that field's value changes. 

It is most useful where you want to do something with only one (unique) 
value from a group of values.  Anyone who has ever written a few lines of 
code to simply skip records until a new key value comes up in an index 
knows what this function is for.

Because of the potential disaster involved with specifying data instead of 
an actual field name, or mistakenly specifying a field name that does 
not exist (or exists but not in the current work area) the field 
name specified in cField is validated and if it does not exist in the 
current working database, the program is terminated by an internal call 
to k_Terminate(). 

k_Skip2Next() returns TRUE if you skipped off the end of the database 
while SKIPping/looking for a new field value. Otherwise it returns FALSE.

NOTE:



EXAMPLE:

k_Skip2Next('LNAME')

LNAME   FNAME
------------------------------------------------
SMITH   John       <- Record Pointer Before Call
SMITH   Frank
SMITH   Wesson
SMITH   Blair
SMYTHE  Jackie     <- Record Pointer After Call
SMYTHE  Orlando

Make sure that you are skipping based on a field that has some order to it.  
Consider...

k_Skip2Next('FNAME')

LNAME   FNAME
------------------------------------------------
SMITH   John       <- Record Pointer Before Call
SMITH   Frank      <- Record Pointer After Call
SMITH   Wesson
SMITH   Blair
SMYTHE  Jackie
SMYTHE  Orlando

And of course, be especially careful with:

k_Skip2Next('M_INIT')

LNAME   FNAME
------------------------------------------------
SMITH   John       <- Record Pointer Before Call
SMITH   Frank
SMITH   Wesson
SMITH   Blair
SMYTHE  Jackie
SMYTHE  Orlando

<BEEP!>
Error: Undefined Field specified in call to _SKIP2NEXT: YourApp Line 287
C:\YOURAPP>
C:\YOURAPP> <blink, blink, blink, blink...>

That's right, if you specify a field that doesn't exist, it cannot very well 
skip to the next one, now can it?

******************************************************************************/


FUNCTION k_Skip2Next(cField)

LOCAL    cThisVal := ""

if fieldpos(cField) = 0
    k_Terminate("Undefined Field specified in call to _SKIP2NEXT: "+procname(1)+ltrim(str(procline(1))))
endif

cThisVal = fieldget(fieldpos(cField))

while fieldget(fieldpos(cField)) == cThisVal .and. (!eof())

    SKIP

end

RETURN(eof())

