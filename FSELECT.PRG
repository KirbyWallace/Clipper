/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_FSelect(cAlias) -->lAliasFound

PARAMETERS:

cAlias : Database Alias to Select

SHORT:

Select a database by work area alias.

DESCRIPTION:

k_FSelect() will search through all open work areas looking for one with the 
alias specified in cAlias.  If an alias is not specifically declared when you 
open a file, the file's alias defaults to the file name so you may still find 
an area with k_FSelect() by specifying the file name for files which you did 
not specify an alias.  File Name excludes File Extention!

Why use k_FSelect() when Clipper's SELECT command will select on an alias 
expression?  SELECT will result in a runtime error if the expression is not a 
valid alias.  k_FSelect() will simply return FALSE if the area is not open or 
will select that area if it is.

k_FSelect() differs from k_Select() in that k_FSelect() looks specifically for 
an ALIAS, whereas k_Select() is dual-purpose in nature and can find a work 
area by number or by Alias.

NOTE:



EXAMPLE:

k_FSelect('BUDGET')

Result: If BUDGET.DBF (or another file opened with the ALIAS BUDGET) is 
open anywhere in the envirnoment, it will be selected and will become 
the current work area.  Else, the work area that was current before the 
call is restored and remains current.

The Return Value is a logical indicating whether the alias was found 
and selected.  TRUE = Yes.

******************************************************************************/

FUNCTION k_FSelect(cAlias)
LOCAL    oldarea := select()
LOCAL    alias_found := .f.
LOCAL    i

FOR i = 1 to 250

    select (i)

    if trim(lower(alias(select()))) = trim(lower(cAlias))
        alias_found = .t.
        exit
    endif

NEXT

if !alias_found .and. i >= 250
    select (OldArea)
endif

RETURN(alias_found)

