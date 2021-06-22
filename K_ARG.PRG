/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Arg( cArgText, cArgStr ) --> cString

PARAMETERS:

cArgText : the specific token to extract from the string
cArgStr  : the string which is to be parsed.

SHORT:

Parse strings to extract text following specfied token.

DESCRIPTION:

k_Arg() extracts from one string, everything that follows a given token up 
to the first space or the end of the string. It is useful for parsing 
command lines.

NOTE:



EXAMPLE:

t = "/sys_sec10 /ftype@ /howdy123"

v = k_Arg('/sys_sec', t )  Result: v = '10'
w = k_Arg('/ftype', t   )  Result: w = '@'
x = k_Arg('/howdy', t   )  Result: x = '123'

******************************************************************************/

FUNCTION k_Arg(cArgText, cArgStr)
LOCAL    i
LOCAL    cRet_Val
LOCAL    nStart
LOCAL    nEnd


if lower(cArgText) $ lower(cArgStr)

    nStart = at(lower(cArgText),lower(cArgStr))+len(cArgText)

    i = 1

    while .t.

        if substr(cArgStr+' ',nStart+i,1) = ' '
            nEnd = i
            EXIT
        endif

        i++

    end

    cRet_Val = substr(cArgStr,nStart,nEnd)

else
    cRet_Val = ''
endif

RETURN(cRet_Val)

