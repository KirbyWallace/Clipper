/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Strtempl(cString, cPattern) --> NIL

PARAMETERS:

cString : String to insert into Template
cPattern: Template to insert string into

SHORT:

Overlays a string with a template, returning the result string.

DESCRIPTION:

_StrTempl (String Template) overlays a string with a given template 
string, and returns the new string. 

cString may be any string, but it must match the number of maskable 
characters in cPattern.  Maskable characters are SPACES in the 
cPattern String!

If cPattern = '- - -', then cString must be exactly 2 characters in length.  
If cPattern = '...-..-....' (with "." representing spaces), then cString must 
be exactly NINE characters in order to be used with that template.

NOTE:



EXAMPLE:

cSSN = '123456789'

t = k_Strtempl(cSSN,'   -  -    ')

Result: t = "123-45-6789"

// cPattern can be pased as variable also:

cPatt = '- - - - - - - - - -'

t = k_Strtempl(cSSN,cPatt)

Result: t = "-1-2-3-4-5-6-7-8-9-"

cPhone = "9188357109"
t = _StrTemp(cPhone,'(   )   -    ")

Result: t = "(918)835-7109"


******************************************************************************/
FUNCTION k_Strtempl(cString, cPattern)
LOCAL    cRetVal := ""
LOCAL    i
LOCAL    n := 1


if k_ChCount(' ',cPattern) = len(cString)

    for i = 1 to len(cPattern)

        if substr(cPattern,i,1) != ' '
            cRetVal += substr(cPattern,i,1)+substr(cString,n,1)
            i++ ; n++
        else
            cRetVal += substr(cString,n,1)
            n++
        endif

    next

endif

RETURN(cRetVal)

