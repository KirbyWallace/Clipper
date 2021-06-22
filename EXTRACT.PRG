/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Extract( cStr, cDelim, nOccurance ) --> cString

PARAMETERS:

cStr       : String to extract characters from
cDelim     : The delimiter character or string
nOccurance : The nth occurance to extract

SHORT:

Extract nth occurance of delimited string from another string.

DESCRIPTION:

k_Extract() will extract from cStr the nth string (specified in nOccurance) 
delimited with the specified delimiter (specified in cDelim).

END OF STRING ALWAYS = DELIMIT CHAR

The end of the string will always count as a match of the delimiter 
character.  That is, the string delimited by the 4th occurance of the 
delimiter "/" in the following string is "FOUR" even though there is no 
actual fourth occurance of the forward slash:

k_Extract("ONE/TWO/THREE/FOUR", '/', 4)

The FIRST occurance of the delimiter character delimits "ONE", the second 
"TWO" etc etc.

NOTE:

The FIRST delimited text cannot be empty(),

i.e. k_Extract('A-B-C-D', '-', 3) will work
i.e. k_Extract('-B-C-D', '-', 3)  will NOT work

Make sure there is no leading delimiter character in the string you 
are testing as in the above case ",B,C,..."

EXAMPLE:

To extract the THIRD number in a series of numbers in a character 
string delimited with commas: 

t = _Exctract('12,34,56,74',',',3)

Result: t = 56

******************************************************************************/

FUNCTION k_Extract(cStr, cDelim, nOccurance)
LOCAL    i
LOCAL    i_count  := 0
LOCAL    cRet_Val := ""


// add first/last delimiters to enable extract of first/last/only occurance

cStr = cDelim+cStr+cDelim

BEGIN SEQUENCE

for i = 1 to len(cStr)

    if substr(cStr,i,1) = cDelim
        i_count = i_count+1

        if i_count = nOccurance

            for i = i+1 to len(cStr)

                if substr(cStr,i,1) = cDelim
                    BREAK
                else
                    cRet_Val = cRet_Val+substr(cStr,i,1)
                endif

            next
        endif
    endif

next

END SEQUENCE

RETURN(cRet_Val)

