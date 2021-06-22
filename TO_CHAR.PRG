/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ToChar( xValue, xFill ) --> cString

PARAMETERS:

xValue : Value to be converted to character type
xFill  : Logical - add leading zeros to numerics (Optional, Default = FALSE)

SHORT:

Convert any data type to string equivalent.

DESCRIPTION:

k_ToChar() accepts any Clipper data type and returns it's character 
equivalent representation.

In the case of Numeric data, spaces are added to the beginning of the 
numeric value to pad to the default length.  This depends upon the 
type numeric it is.  Double precision integers occupy 16 places.  For 
numeric field data, the length is specified in the file structure.  If 
xFill is passed as TRUE, these leading spaces are filled with ZEROS.

If xFill is passed as a numeric, then numeric data types are stringified 
to that length.  If the length specified in xFill is less than or equal to 
the length of the number being converted, the length of the number is 
unaffected:


k_ToChar(501,4)  = " 501"
k_ToChar(501,3)  = "501"
k_ToChar(501,2)  = "501"


When xFill is numeric, nDec can be specified to control the number of 
decimal places retained during conversion.

If nDec is not specified, the current SET DECIMALS setting is used.

For Logical data types, the return val is a "Y" or "N".

Finally, (xValue = NIL) returns ""

NOTE:



EXAMPLE:

k_ToChar(1001)       // "1001"
k_ToChar(1001,5)     // " 1001"
k_ToChar(1001,8)     // "    1001"

k_ToChar(date())     // "01/01/93"

k_ToChar(.F.)        // "N"


******************************************************************************/

FUNCTION k_ToChar(xValue,xFill,nDec)
LOCAL    xRet_Val := ''

if xFill = NIL
    xFill = .f.
endif

do case

    case valtype(xValue) = 'N'

        if valtype(xFill) = 'N'
            if valtype(nDec) != 'N'
                xRet_Val = str(xValue,xFill)
            else
                xRet_Val = str(xValue,xFill,nDec)
            endif
        else
            xRet_Val = str(xValue)
        endif


        if valtype(xFill) = 'L'
            if xFill
                xRet_Val = strtran(xRet_Val,' ','0')
            endif
        endif


    case valtype(xValue) = 'D'
        xRet_Val = dtoc(xValue)

    case valtype(xValue) = 'C'
        xRet_Val = xValue

    case valtype(xValue) = 'L'
        xRet_Val = iif(xValue,'Y','N')

    case valtype(xValue) = 'M'
        xRet_Val = xValue

endcase

RETURN(xRet_Val)

