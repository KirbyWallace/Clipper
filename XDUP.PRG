/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_XDup( cOutFile, lKeep ) --> nRecsDeleted

PARAMETERS:

cOutFile  : Optional - Output file to contain duplicate records
lKeep     : Keep First/Last occurance. TRUE = First (default) FALSE = Last

SHORT:

Delete duplicate records in a database based upon index key.

DESCRIPTION:

k_XDup() will check the file in the CURRENT WORKAREA for duplicate records 
ACCORDING TO THE FILE'S CURRENT INDEX KEY.  When duplicates are found, if 
cOutFile is not specified, the duplicate records are deleted.  If cOutFile is 
specified, duplicate records are deleted after being copied to the file named 
in cOutFile. 

If lKeep = TRUE, the FIRST record from a group of duplicate records is kept, 
the rest are deleted/copied.  If FALSE, then the LAST record from a group of 
duplicates is kept/copied. 

k_XDup() returns the number of duplicate records deleted. If no index is 
currently open, the function immediately returns -1.

The file being checked must be open in EXCLUSIVE mode.

NOTE:

This is not a thouroughly tested function.  Use caution.

EXAMPLE:

USE file.dbf
SET INDEX TO file.ntx  // keyed on LastName+FirstName

k_XDup()


Result: No parameters were passed, so the defaults of No Copy File and 
Keep First apply.  All duplicate records are simply deleted and the 
FIRST occurance of each duplicate is kept.

k_XDup('TEMP.DBF',FALSE)

Result: Duplicate records are copied to TEMP.DBF before being deleted.  
The LAST record in each group of duplicates is kept.

******************************************************************************/

FUNCTION k_XDup(cOutFile,lKeep)

LOCAL    nRet_Val := 0
LOCAL    this_key
LOCAL    this_val


if indexord() = 0
    return(-1)
endif

if lKeep = NIL
    lKeep = .t.
endif

goto top

do while !eof()

    this_key = indexkey(indexord())
    this_val = &this_key

    do while !eof()

        skip

        if lKeep
            if &this_key = this_val
                DELETE
                nRet_Val++
            else
                skip -1
                exit
            endif
        else

            DELETE

            nRet_Val++

            if &this_key != this_val
                skip -1
                RECALL
                nRet_Val--
                exit
            endif
        endif

    enddo

    skip

enddo

RETURN(nRet_Val)

