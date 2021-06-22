/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_PullCap( cPullString ) --> cString

PARAMETERS:

cPullString : String to extract CAPS from

SHORT:

Upper Case first letters of a string and extract them.

DESCRIPTION:

k_PullCap() capitalizes the first letter of each word in a string (separated 
by spaces) then extracts and returns only the capital letters from a string.  

It ignores digits. It is useful for creating acronyms for such things as 
creating file names from a long string.

NOTE:



EXAMPLE:

Create_File = k_PullCap('temporary & intermdiate accounts 101 budget 
file')+'.DBF'

Result: Create_File = 'TIABF.DBF'

******************************************************************************/

FUNCTION k_PullCap(cPullString)
LOCAL    i
LOCAL    cOutString := ''
LOCAL    pull_arr[len(cPullString)]

cPullString = k_CapFirst(cPullString)

for i = 1 to len(cPullString)

    if isupper(substr(cPullString,i,1)) .and. isalpha(substr(cPullString,i,1))
        cOutString += substr(cPullString,i,1)
    endif

next

RETURN(cPullString)

