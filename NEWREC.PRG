/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_NewRec( lNewRec_DateStamp ) --> lAppendStatus

PARAMETERS:

lNewRec_DateStamp : TRUE = Date Stamp record if possible
                    FALSE = No date stamp, even if possible (DEFAULT)

SHORT:

Append a new record to the current database, optionally with date/time stamp.

DESCRIPTION:

k_NewRec() is a general purpose record appending function.

The only difference between this and a straight APPEND BLANK is that this 
function will date/time stamp the record *IF* it has fields called 
ADD_DATE,D,8,0 and ADD_TIME,C,8,0 *AND* lNewRec_DateStamp = TRUE.

This can be disabled by passing a logical FALSE as an argument to the 
function:

k_NewRec(FALSE) appends a new record and does NOT date/time stamp it even if 
it DOES have the Add_Date/Add_Time fields.

Returns: TRUE if record is appended, else FALSE.


NOTE:



EXAMPLE:

k_NewRec()  // new record appended, no stamp even if fields present
k_NewRec(.T.) // new record appended, date stamp if fields present

******************************************************************************/

FUNCTION k_NewRec(lNewRec_DateStamp)
LOCAL    lRet_Val := .f., i

lNewRec_DateStamp = iif(lNewRec_DateStamp = NIL,.t.,lNewRec_DateStamp)

while (i := inkey()) != 27

    append blank

    if !neterr()
        lRet_Val = .t.
        exit
    else
        k_KeyList('Record or File is unavaliable, Retrying Record Lock...')
    endif

end

if lNewRec_DateStamp

    if type('ADD_DATE') = 'D'
        replace Add_Date with date()
    endif

    if type('ADD_TIME') = 'C'
        replace Add_Time with time()
    endif

endif

return(lRet_Val)

