/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_CapFirst( cCap_Str ) --> cString

PARAMETERS:

cCap_Str : string to capitalize

SHORT:

Return a string with captialized first letters.

DESCRIPTION:

k_CapFirst() will capitalize each first letter that follows a space.

NOTE:



EXAMPLE:

cString1 = 'now is the time for all good men'
cString2 = k_CapFirst(cString1)

Result: cString2 = 'Now Is The Time For All Good Men'

? k_CapFirst('kirby l. wallace, tulsa ok.')

Result: "Kirby L. Wallace, Tulsa Ok."

******************************************************************************/

FUNCTION k_CapFirst(cCap_Str)
LOCAL    i
LOCAL    cap_arr[len(cCap_Str)]

for i = 1 to len(cCap_Str)
    cap_arr[i] = lower(substr(cCap_Str,i,1))
next

for i = 1 to len(cap_arr)

    if i = 1
        cap_arr[i] = upper(cap_arr[i])
    endif

    // prevent reference past last element
    if cap_arr[i] = ' ' .and. i < len(cap_arr)
        cap_arr[i+1] = upper(cap_arr[i+1])
    endif

next

cCap_Str = ''

for i = 1 to len(cap_arr)
    cCap_Str = cCap_Str+cap_arr[i]
next

RETURN(cCap_Str)

