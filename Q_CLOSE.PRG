/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_QClose( cTable, cAlias ) --> NIL

PARAMETERS:

cTable - Database Table to Open
cAlias - Alias to use for this table in this area

SHORT:

Quick Close a file in-line.

DESCRIPTION:

_Q_Close is used specifically for closing a database table opened 
by k_QOpen().  You must pass the Table name and alias exactly as you 
passed them to k_QOpen() because the same formula for identifying the 
database that is used there is also used here.

NOTE:



EXAMPLE:

k_QClose('ACTIVITY.DBF','ACODE')

ACTIVITY.DBF is closed and it's index file.

******************************************************************************/
#include "klipper.ch"

FUNCTION k_QClose(cTable, cAlias)

if cAlias = NIL
    cAlias = k_Convert(substr(trim(cTable)+repl('x',10),1,10))
endif

SELECT &cAlias
CLOSEAREA

RETURN(NIL)



