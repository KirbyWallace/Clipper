/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_QOpen( cTable, cAlias, cIndex, lXFlag ) --> nSelectArea

PARAMETERS:

cTable - Database Table to Open
cAlias - Alias to use for this table in this area
cIndex - Index to Open, if not specified, defaults to k_SetIndex(cTable)
lXFlag - Exclusive use flag, TRUE = Exclusive

SHORT:

Quick Open a file in-line.

DESCRIPTION:

_Q_Open is useful for performing an inline database open as it can be 
called as an inline function.

Returns: Alias of the current work area.  This should equal the database 
you requested.

NOTE:



EXAMPLE:

k_QOpen('ACTIVITY.DBF','ACODE','ACTIVITY.NTX',FALSE)

ACTIVITY.DBF is opened in SHARED mode next available work area under alias 
ACODE and the index ACTIVITY.NTX is opened.

******************************************************************************/
FUNCTION k_QOpen(cTable, cAlias, cIndex, lXFlag)

if cAlias = NIL
    cAlias = k_Convert(substr(trim(cTable)+repl('x',10),1,10))
endif

if lXFlag = NIL
    lXFlag = .f.
endif

if lXFlag
    k_XUse(cTable,cAlias,0)
else
    k_SUse(cTable,cAlias,0)
endif

if !neterr()
    SET INDEX TO (cIndex)
endif

RETURN(alias())

