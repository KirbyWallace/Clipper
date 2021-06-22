/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_CheckIndex(cDName, cNName, cKey ) --> NIL

PARAMETERS:

cDname : Database File Name
cIname : Index File Name
cKey   : Index Key

SHORT:

Check and, if missing, build an index file.

DESCRIPTION:

k_CheckIndex() allows a quick, or in-line check of an index file and builds 
it according to parameter information if it does not exist.

Note: This function assumes NOTHING.  You must make sure that the 
database file exists, and that the index key is valid for the 
specified database.


The database specified in cDName must not be open in any work area.  
For obvious reasons, the function cannot open the database exclusively 
in order to build the index if it is open elsewhere.

Thus, you should call this function before opening your databases. 
Regardless, this function returns NIL.

NOTE:



EXAMPLE:

k_CheckIndex('BUDGET.DBF','BUDGETACC.NTX','Budget->Account_Num')

If BUDGET.NTX does not exist, BUDGET.DBF is opened exclusively and indexed on 
Budget->ACCOUNT_NUM.

******************************************************************************/


FUNCTION k_CheckIndex( cDName, cNName, cKey )

if !file(cNname)

    USE (cDName) ALIAS x NEW EXCLUSIVE

    INDEX ON &cKey TO &cNname

    USE

endif

RETURN(NIL)

