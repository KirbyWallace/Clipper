/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ParseIdentifiers( cString ) --> cDelimitedString

PARAMETERS:

cString : The string to parse identifiers out of

SHORT:

Get a comma delimited string of Clipper identifers from another string.

DESCRIPTION:

k_ParseIdentifiers() will extract all Clipper identifiers from a given string.
This is useful for, fr'instance, creating a list of fields from an index
expression.


The identifiers in the example index key are "descend" (function name)
"PoopGROK" (function name), "BZT_FRAK" (alias), and "Mumiz" (database field).
So the return string will be:

    "descend,PoopGROK,BZT_FRAK,Mumiz"


NOTE:

This function is used by k_FieldStr() which extracts only field names from
a given string expression.

EXAMPLE:

"Mumiz" is a database field in BZT_FRAK.DBF

USE BZT_FRAK ALIAS BZT_FRAK

INDEX ON PoopGROK(BZT_FRAK->Mumiz, "Mumiz" ) TO MONGA

? k_ParseIdentifiers( indexkey(indexord()) )

Index Key transformation:

descend(PoopGROK(BZT_FRAK->Mumiz, "Mumiz" ))  // original index key expression
descend(PoopGROK(BZT_FRAK->Mumiz,         ))  // remove quoted material
descend PoopGROK BZT_FRAK  Mumiz              // remove punctuation
descend,PoopGROK,BZT_FRAK,Mumiz            // replace double spaces with commas



******************************************************************************/

FUNCTION k_ParseIdentifiers( cString )

LOCAL    cOutString := ""
LOCAL    cStopChar  := ""
LOCAL    cChar      := ""

LOCAL    i

for i = 1 to len( cString )

    *-- if a string delimiter is encountered, note which one - will be skipping all other string delimiters
    *-- that are themselves enclosed within this one:
    *--
    *--   "Thanks to Dad's ingenuity in crafting bracket marks like '[' and ']', we all escaped safely..."
    *--   |             ^                                             ^      ^^                          |
    *--
    *--  In this case we are going to skip altogether the single quotes and right brackets that would
    *--  ordinarily end a string because they themselves are part of another string delimited with the
    *--  double quotes.


    if substr(cString,i,1) $ "'["+'"'

        cStopChar = substr(cString,i++,1)

        if cStopChar = "["
            cStopChar = "]"
        endif

        for i = i to len(cString)
            if substr(cString,i,1) = cStopChar
                i++
                EXIT
            endif
        next

    endif

    cChar = substr(cString,i,1)

    if isalpha(cChar) .or. ;
       isdigit(cChar) .or. ;
       cChar = "_"

        cOutString += cChar

    else
        cOutString += " "

    endif


next

*-- this "while at() > 0" check *is* necessary since replacing TWO concurrent double-spaces
*-- will result in yet another double-space. X and Y represent spaces: ( XXYY --> XY --> X )
*--                                                                      ----     --     -

cOutString = alltrim(cOutString)

while at("  ", cOutString) > 0
    cOutString = strtran(cOutString,"  "," ")
end

cOutString = strtran(cOutString," ",",")

RETURN( cOutString )

