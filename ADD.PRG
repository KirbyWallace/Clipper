/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Add( cNum1, cNum2 ) --> cString

PARAMETERS:

cNum1: First Number String
cNum2: Second Number String to add to first

SHORT:

Perform addition up to 64,000 digits (I swear I'm not making this up!)

DESCRIPTION:

k_Add() performs addition on STRINGS that represent numbers to add together.  
k_Add() is used primarily to perform addition on numbers that exceed 16 digit 
precision.

NOTE:

For additions that DO exceed 16 digits, you cannot convert the results to 
numeric because you will lose digits in the conversion.

Also, number strings must represent positive whole numbers.  k_Add() will not 
handle addition of negative numbers, or numbers with decimal fractions.

See also, k_Mult() which does similar things with multiplication.

EXAMPLE:

? k_Add('11111111111111111111','22222222222222222222')

Result:   "33333333333333333333"

Numbers do not have to exceed 16 digits in order to use k_Add()

? k_Add('99','1')

Result: "100"


******************************************************************************/
FUNCTION k_Add(cNum1,cNum2)
LOCAL cResult := ''
LOCAL nCarry := 0, i

// find longest string, pad other to length with zeros

cNum1 = alltrim(cNum1)
cNum2 = alltrim(cNum2)

if len(cNum1) > len(cNum2)
    cNum2 = repl('0',len(cNum1)-len(cNum2))+cNum2
else
    if len(cNum2) > len(cNum1)
        cNum1 = repl('0',len(cNum2)-len(cNum1))+cNum1
    endif
endif

for i = len(cNum1) to 1 STEP -1
    if ( val(substr(cNum1,i,1))+val(substr(cNum2,i,1)) ) + nCarry  >= 10
        cResult = ltrim(str(val(substr(cNum1,i,1))+val(substr(cNum2,i,1)) + nCarry - 10)) + cResult
        nCarry = 1
    else
        cResult = ltrim(str(val(substr(cNum1,i,1))+val(substr(cNum2,i,1)) + nCarry )) + cResult
        nCarry = 0
    endif
next

if nCarry > 0
    cResult = '1'+cResult
endif

RETURN(cResult)

