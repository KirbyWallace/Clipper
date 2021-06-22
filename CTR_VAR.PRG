/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_CtrVar( cCenterStr ) --> cString

PARAMETERS:

cCenterStr : String to be centered

SHORT:

Center (redistribute) a string within it's own length.

DESCRIPTION:

k_CtrVar() takes a string with trailing spaces and repositions the non-blank 
portion within the length of the variable itself. The trailing spaces are 
evenly redistributed to the begin and ending of the non-blank value.  This is 
really simple!!!!

NOTE:



EXAMPLE:

cString1 = k_CtrVar('THIS IS A VARIABLE                 ')
Result:  cString1 = '         THIS IS A VARIABLE        '

******************************************************************************/

FUNCTION k_CtrVar(cCenterStr)
LOCAL    nStrlen      := len(cCenterStr)
LOCAL    nSpace_Chars :=  (len(cCenterStr)-len(trim(cCenterStr)))/2

cCenterStr  = space(nSpace_Chars)+trim(cCenterStr)+space(nSpace_Chars)

*/ because we lose one space when "space_chars/2" where space_chars is odd  /*

if len(cCenterStr) <> nStrlen
    if nStrlen > len(cCenterStr)
        cCenterStr=cCenterStr+' '
    endif
endif

RETURN(cCenterStr)

