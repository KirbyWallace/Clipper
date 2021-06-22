/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_FieldString( cStringExpr ) --> cFieldList

PARAMETERS:

cStringExpr : Clipper expression from which to extract field names

SHORT:

Extract field names from current database from any string expression.

DESCRIPTION:

k_FieldString() extracts field names that are referenced in any Clipper
string expression, such as INDEXKEY().

NOTE:

EXAMPLE:

"Bongo" and "Mumiz" are database fields in BZT_FRAK.DBF

USE BZT_FRAK ALIAS BZT_FRAK

INDEX ON Descend(Bongo) + PoopGROK(BZT_FRAK->Mumiz, "Mumiz" ) TO MONGA

t = k_FieldString( indexkey(indexord()) )

Result: t = "Bongo,Mumiz"

******************************************************************************/

FUNCTION k_FieldString( cString )

LOCAL    cIdentString := ""
LOCAL    cFieldString := ""
LOCAL    cTemp        := ""

LOCAL    i, j

cIdentString = k_ParseIdentifiers( cString )

// have a string with whole word identifiers only, no puntuation or quoted string material, separated
// by single spaces, suitable for looking at one at a time with k_NthOccr() to compare against fieldlist.

for i = 1 to k_ChCount(",",cIdentString)+1

    cTemp = upper(k_Extract( cIdentString, ",", i ))

    for j = 1 to fcount()

        *-- it is perfectly acceptable to reference field names in variables that exceed the
        *-- ten character field name length.  ContractNum is perfectly acceptable even when
        *-- the fieldname is "CONTRACTNU".  This, however, will cause a fail on the "==" operator.
        *-- To get around it, compare only the number of characters that are in the fieldname
        *-- returned by the field() function.  Note that cTemp has already been upper()'d.

        if  substr(cTemp,1,len(field(j))) == upper(field(j))
            cFieldString += cTemp+","
            EXIT
        endif

    next

next

if right(cFieldString,1) = ","
    cFieldString = alltrim(substr(cFieldString,1,len(cFieldString)-1))
endif

RETURN( cFieldString )

