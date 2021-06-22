/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ReIndex( acFileName ) --> NIL

PARAMETERS:

cFileName : (Optional) array of databases to reindex. (Default = ALL dbfs)

SHORT:

Reindex databases according to index specifications on file.

DESCRIPTION:

k_ReIndex() uses the DATALINK.DAT file to create index files for the databases 
listed therein.

The structure of the DATALINK.DAT file should be:

FILE_NAME,  C, 8
FILE_EXT,   C, 3
OWNER_NAME, C, 8
OWNER_EXT,  C, 3
OWNERALIAS, C, 15
INDEX_KEY,  C, 75
FILE_DESC,  C, 75
LAST_NTXD,  D
LAST_NTXT,  C, 8
USE_COUNT,  N, 12
PACK,       L
MEMOPACK,   L
INCLUDE,    L
MAX_RECS,   N, 10
MAX_RFILE,  C, 12
MAX_DATE,   D
MAX_DAYS,   N, 8
DATE_FIELD, C, 10
MAX_DFILE,  C, 12
FLAG,       C, 1

This file is created on the first call to k_ReIndex() or to k_SetIndex() if the 
file does not exists.  It is created empty and therefore needs to be filled 
in with data concerning the files that you wish to have indexed.

Indexing Sub-System

OVERVIEW

The Index Sub-System provides a mechanism for automating the indexing, 
packing, memo file condensing, and rudimentary record archiving of 
application databases [the k_ReIndex() function]; and, an index file 
management function that automates the opening of indexes for application 
databases [the k_SetIndex() function].

Both of these functions use an Index Control File that contains data that 
describes the databases, indexes, and other information.  (The default name 
of this file is MENUDEF.DAT, however, the calling application may change this 
name to any other valid file name.  See Technical Details.)  Each record in 
this Table identifies either 1) an index that is to be associated with a 
particular database, or 2) a database file that is to be processed in some 
form during reindexing. 

The k_ReIndex() function is called typically as a stand-alone procedure.  
Ordinarily, it will be called directly from a menu item while there are no 
databases open (including other users in a network environment).  The nature 
of a complete database index is such that the files must be opened 
exclusively, and that is what k_ReIndex() does.  Any database file that 
k_ReIndex() cannot open in EXCLUSIVE mode is skipped and not reindexed, or 
processed in any way.

When k_ReIndex() begins processing, it processes each file named in the Index 
Control File in the physical order that they appear, according to the various 
options that are defined in each record.  (See Technical Details for indepth 
description.)  Some may be requests to build indexes, others may be requests 
to perform any of the various archiving functions, or a combination of both.

k_SetIndex(), uses the same Index Control File, but for a different purpose.  
k_SetIndex() is used to open indexes for a database.  When k_SetIndex() is 
called, it refers to the Index Control File to gather information on all 
indexes that are related to the database specified.  It then opens ALL 
indexes associated with that database.  The primary advantage is that the 
programmer is spared the burden of remembering to open all indexes that have 
been created for any given database, the system tracks these details.  When 
you call k_SetIndex(), you are assured that all index files for the specified 
database will be opened and updated as edits are made.  In addition to 
opening multiple index files, the k_SetIndex() function can be told to make 
one of those indexes the primary (or controlling) index.

TECHNICAL DETAILS

k_ReIndex() Function

The database administration is data driven by means of an Index Control File. 
 The structure of this file is as follows:

FILE_NAME,  C, 8
FILE_EXT,   C, 3
OWNER_NAME, C, 8
OWNER_EXT,  C, 3
OWNERALIAS, C, 15
INDEX_KEY,  C, 75
FILE_DESC,  C, 75
LAST_NTXD,  D
LAST_NTXT,  C, 8
USE_COUNT,  N, 12
PACK,       L
MEMOPACK,   L
INCLUDE,    L
MAX_RECS,   N, 10
MAX_RFILE,  C, 12
MAX_DATE,   D
MAX_DAYS,   N, 8
DATE_FIELD, C, 10
MAX_DFILE,  C, 12
FLAG,       C, 1

The following is an explanation of these fields.

FILE_NAME: The FILE name of the INDEX FILE.

FILE_EXT: The file name EXTENSION of the INDEX FILE.

OWNER_NAME: The FILE name of the corresponding DATABASE.

OWNER_EXT: The file name EXTENSION of the DATABASE.

OWNERALIAS: The ALIAS name to be used when opening the file for indexing.  
(Aliases affect the index key if specified in the index key expression, thus 
this may be necessary if you include alias information in the index key 
itself.) 

INDEX_KEY: This is any valid Clipper Index Expression on which to build the 
index. 

FILE_DESC: This is a text field that can be used to describe the index file 
and it's purpose.  It is optional and is not used by the Index Sub-System in 
any way.

LAST_NTXD: This field is maintained by the Index Sub-System and contains the 
DATE() that the index was last built.

LAST_NTXT: This field is maintained by the Index Sub-System and contains the 
TIME() that the index was last built.

USE_COUNT: This field is maintained by the Index Sub-System and keeps a 
running count of the number of times that the index has been used by the 
indexing routines (k_ReIndex()) and by the k_SetIndex() function.

PACK: This is a logical field.  If it contains a logical TRUE, then this 
database file is PACKED when the Index Sub-System rebuilds indexes.  If it 
contains a logical FALSE, this file is NOT packed.  Note that if you have 
requested any of the record archive features, the file will also be packed, 
even if PACK is FALSE.

MEMOPACK: This is a logical field.  If it contains a logical TRUE, then this 
database's MEMO FILE (.DBT) is PACKED when the Index Sub-System rebuilds 
indexes.  If it contains a logical FALSE, this file's memo file is NOT 
packed.  If the specified database has no memo field(s), then MEMOPACK is not 
executed, even if requested.

Memo Files allocate disk storage in 512K blocks.  When a particular memo 
field overflows this 512K block, the entire block is copied to a new block at 
the end of the file, and more space is allocated.  The original block is then 
marked as being unused, but remains a part of the .DBT file.  (More detailed 
information can be found in the Clipper 5.0 Reference Manual).  For this 
reason, memo fields tend to grow exponentially.  Specifying TRUE in this 
field causes the memo file to be rewritten, eliminating unused blocks.

INCLUDE: This is a logical field.  If it contains a logical TRUE, then this 
database file is included for processing when the Index Sub-System rebuilds 
indexes.  If it contains a logical FALSE, this file is NOT packed.

If a file is INCLUDED, all actions specified for that file are accomplished.  
This includes indexing, packing, memopacking, record archiving, etc.  If 
INCLUDE contains a logical FALSE, no processing of any type is performed. 

The following six fields are responsible for record archiving and deletion 
based upon three criteria: Age, Date, and Number of Records on File.

There are three ways to automatically remove records from the database files 
referenced in the Index Control File.  The first way is to specify a maximum 
number of records that the file can contain before the excess records are 
deleted.  The second and third ways are similar, but operate on slightly 
different principles.  You specify a date field in the database to be used in 
a comparison AND EITHER a date before which records will be deleted, OR a 
maximum number of days old a record can be before it is deleted.  This is not 
a rigid either/or situation, you can specify both.  In fact, you can specify 
all three criteria for a single database along with the index key for 
indexing all in one Index Control File record.

MAX_RECS:  This numeric field, if not zero, is used to remove records based 
upon how many records are in the database file.  For instance, if this field 
contains 100, then only the LAST 100 records will remain in the file.  All 
records other than the last 100 are deleted.

Notice that specifying a non-zero number in this field causes the database to 
be PACKED regardless of whether the PACK field is TRUE or FALSE.

MAX_RFILE: This character field can contain a file name.  If it is a valid 
file name, records that are deleted based upon MAX_RECS are copied to this 
file BEFORE being deleted from the application database file.  This makes it 
possible to MOVE records from the database file to an archive file.

MAX_DATE:  This date field works in conjunction with the application database 
field specified in the DATE_FIELD field to remove records based upon a date 
comparison.  If a non-blank date is entered here, then only those records 
whose DATE_FIELD field is greater than MAX_DATE remain.  All others are 
deleted. 

MAX_DAYS:  This numeric field works in conjunction with the application 
database field specified in the DATE_FIELD field to remove records based upon 
a date comparison.  If a non-zero number is entered here, then only records 
that are less than MAX_DAYS number of days from the date in the DATE_FIELD 
field remain.  All others are deleted.

DATE_FIELD:  This is the date field in the application database that is used 
for comparisons against MAX_DATE and MAX_DAYS.

MAX_DFILE:  This character field contains a file name into which are move 
records that are deleted by the MAX_DAYS and MAX_DATE functions.  If this 
field is empty, records deleted by date comparisons are simply deleted. If 
this field contains a valid file name, then those records deleted by the date 
comparisons are copied here BEFORE being deleted.  This makes it possible to 
create an archive file of records that are moved out of the application 
database based upon a cutoff date or age.

Index Status Report

The database Index Control File is used to rebuild all indexes and perform 
record archiving whenever your application makes a call to k_ReIndex().  When 
this call is made, a prompt is presented asking whether or not to print a 
status report.  This prompt overlays the application screen and restores the 
screen to it's previous state once the question has been answered. 

Screen Activity during Processing

During processing, a box is presented that informs you of the progress of the 
processing.  As each record in the Index Control File is encountered, the 
status box is updated to reflect which file is currently being processed and, 
as options are encountered, they are presented also: 

PACK: The database is currently being packed

MEMOPACK: The database memo fields are being condensed.

NO MEMOS: A MEMOPACK was requested on the current database, but the file has 
no memo fields. The MEMOPACK request is ignored, and this information message 
is displayed for appx one second.

ARCHIVE-R: The database is being processed to remove records based upon 
Maximum Records Criteria. 

ARCHIVE-D1: The database is being processed to remove records based upon a 
Date Cutoff Criteria. 

ARCHIVE-D2: The database is being processed to remove records based upon a 
Date Age Criteria.

k_SetIndex() Function

The k_SetIndex() function uses the same Index Control File to locate and open 
application database indexes.  However, it is makes reference only to the 
following fields:

OWNER_NAME/OWNER_EXT: These fields are compared against the specified 
application database name to determine whether the index contained in 
FILE_NAME/FILE_EXT are to be opened for the current application database. 

If the index is determined to belong to the specified application database, 
then the index is opened, and the USE_COUNT field for this OWNER_NAME is 
incremented by one. This information field can be used to determine the 
frequency of use for the various application databases and indexes.  Note 
that this field is incremented each time the INDEX specified in FILE_NAME is 
opened by k_SetIndex() and each time the DATABASE specified in the OWNER_NAME 
field is opened.

Calling Convention and Parameters

IMPORTANT NOTE:  The Index Sub-System should be called when all databases are 
closed.  Typically, you should have a menu option called, "Database 
Indexing", or something similar from which the indexing Sub-System function 
is called.  Indexing requires EXCLUSIVE use of each of the databases.

Syntax:

k_ReIndex([acOwner])

The function takes one optional parameter.  If you do not wish to reindex ALL 
databases specified in the Index Control File, you may optionally pass, as a 
parameter, a character array containing one file name per element that you 
wish to include in this pass.  Example:

LOCAL aFiles1 := { 'BUDGET.DBF' }
LOCAL aFiles2 := { 'BUDGET.DBF','FORECAST.DBF' }

k_ReIndex()
k_ReIndex(aFiles1)
k_ReIndex(aFiles2)

In the first call, all databases in the Index Control File will be processed. 

In the second call, only BUDGET.DBF will be processed.  In the final example, 
both BUDGET.DBF and FORECAST.DBF will be processed. 

Syntax:

k_SetIndex( cTableName [,cInitControl] )

The function takes two parameters, the second is optional. The first 
parameter is the name of the application database that you wish to open 
indexes for.  There may be up to 15 indexes per database file.  If no 
associated index information is found in the Index Control File, then no 
indexes are opened.

As the Index Control File is scanned, index information is gathered in the 
order that they occur in the file.  The Index Control File is itself ordered 
by OWNER_NAME, but inside that, physical record order is the only order.  
Therefore, the index files will be listed in the order that they were 
entered.  Once all of the index files have been identified for a given 
database, k_SetIndex() then attempts to decide which of the indexes should be 
made the controlling index.  In other words, which order will it SET ORDER 
TO...?

If the cInitControl parameter is NOT passed, k_SetIndex() will attempt to make 
the index that has the same FILE_NAME as OWNER_NAME.  If BUDGET.DBF is the 
name of the database, and three indexes for BUDGET.DBF are specified:

k_SetIndex('BUDGET.DBF')

BUDGT91.NTX
BUDGET.NTX
BUDGT90.NTX

then the controlling index will be BUDGET.NTX because it has the same file 
name as the database file.

The second, optional parameter, cInitControl is used to give controlling 
order to one of the indexes.  For instance, in the above example, if you 
explicitly wanted to make BUDGT91.NTX the controlling index, your function 
call would have been:

k_SetIndex('BUDGET.DBF','BUDGT91.NTX')

If you specifically name a controlling index in cInitControl parameter, and 
that file does not exist in the Index Control File (even if the file exists 
on the disk), then the program will terminate with a programmed Run-Time 
Error Message.  The reason for this is that because the cInitControl argument 
is optional, if you specify it, and do not know that it doesn't exist in the 
Index Control File, then you are asking for an Abnormal Termination and 
Run-Time error shortly thereafter, or worse, erratic behavior from the 
system.  If you specify a controlling index, you MUST make certain that it 
exists in the Index Control File.

NOTE:



EXAMPLE:

k_ReIndex()

Result: All files specified in DATALINK.DAT are indexed

k_ReIndex({'MAIN.DBF'})

Result: All indexes specified for MAIN.DBF in the DATALINK.DAT file are 
built.

******************************************************************************/


FUNCTION k_ReIndex(acOwner)

#include "klipper.ch"
#include "kfile.ch"

LOCAL    i
LOCAL    nOld_Area   := Select()

LOCAL    cNtx_Key    := '', ;
         cNtx_Name   := '', ;
         cTable_Name := ''

LOCAL    lFileSpec   := FALSE, ;
         lMemo_Opt   := FALSE, ;
         lMem_Here   := FALSE, ;
         lNew_Page   := TRUE, ;
         lPack_Opt   := FALSE, ;
         lStat_Rep   := FALSE

LOCAL    nMax_Area   := 0, ;
         nFC         := 0, ;
         nNtxs       := 0, ;
         nRecs       := 0, ;
         nTables     := 0


FIELD    FILE_NAME,  ;
         FILE_EXT,   ;
         OWNER_NAME, ;
         OWNER_EXT,  ;
         OWNERALIAS, ;
         INDEX_KEY,  ;
         FILE_DESC,  ;
         LAST_NTXD,  ;
         LAST_NTXT,  ;
         USE_COUNT,  ;
         PACK,       ;
         MEMOPACK,   ;
         INCLUDE,    ;
         MAX_RECS,   ;
         MAX_RFILE,  ;
         MAX_DATE,   ;
         MAX_DAYS,   ;
         DATE_FIELD, ;
         MAX_DFILE,  ;
         FLAG

MEMVAR   _KFILEPATH, ;
         _KMENUNAME, ;
         _KINDEXNAME,;
         _KINDEXIDX

MEMVAR   nMaxRecs,   ;
         cMaxRFil,   ;
         cmaxDFil,   ;
         Help_Label, ;
         GetList

PRIVATE  cDateFld, ;
         dMaxDate, ;
         cMaxDFil, ;
         cMaxRFil, ;
         nMaxDats, ;
         nMaxRecs, ;
         GetList,  ;
         Help_Label



EXTERNAL descend

if type('_kfilepath') != 'C'
    PUBLIC _kfilepath := ''
endif

if type('_KINDEXNAME') != 'C'
    PUBLIC _KINDEXNAME := 'DATALINK.DAT'
endif

if type('_KINDEXIDX') != 'C'
    PUBLIC _KINDEXIDX := 'DATALINK.TIF'
endif


BEGIN SEQUENCE

    lFileSpec = iif(pcount() = 0,FALSE,TRUE)

    if ( !file(_kfilepath+'datalink.dat') )
        __makeidxfile()
        break
    else

        // use &_kfilepath.datalink.dat EXCLUSIVE

        k_XUse(_KINDEXNAME,'DATALINK',0) // k_XUse() accounts for _kfilepath; _kfilepath !necessary

        if neterr()
            k_Terminate('INDEXSUBSYS: _RE_INDEX(): Cannot Get Exclusive CONTROL FILE')
        else

            // _KINDEXNAME itself is reindexed also

            INDEX ON lower(owner_name) TO (_KFILEPATH+_KINDEXIDX)

            REPLACE Use_Count  WITH Use_Count+1, ;
                    last_ntxd  WITH date(),      ;
                    last_ntxt  WITH time()

            // _Re_Index() processes all files sequentially, no index needed here.
            // Index is built here for use by KLIPPER.LIB->k_SetIndex()

            SET INDEX TO

        endif

    endif

    // hook into on-line help system in KLIPPER.LIB->SYS_HELP.PRG

    PRIVATE Help_Label := 'SETNTXSTATREP'

    nTables = 0
    nNtxs   = 0
    nRecs   = 0

    lNew_Page = TRUE

    GOTO TOP

    k_ToScr()

    while !eof()

        if !empty(Owner_Name+Owner_Ext) // files MUST have file extention

            // Following deals with using a file spec in a PUBLIC array called lFileSpec
            // if specific file was requested, skip all others.

            if lFileSpec

                if !( k_InArray(acOwner,trim(Owner_Name)+'.'+trim(Owner_Ext)) )
                    SKIP
                    LOOP
                endif

            endif

            // if include field not TRUE, do not include in this pass
            // if specific file requested, accept even if Include = FALSE.

            if !Include .and. !lFileSpec
                SKIP
                LOOP
            endif

            cTable_Name = trim(Owner_Name)+'.'+trim(Owner_Ext)

            // ignore any attempt to reindex the index control file or the menu definition file
            // if they have been included in the index control file.

            if lower(cTable_Name) = lower(_KINDEXNAME) .or. ;
               lower(cTable_Name) = iif(type('_KMENUNAME') = 'C',lower(_KMENUNAME),'menudef.dat')

                k_KeyList('Ignoring Redundant Call to Internal System File...')
                inkey(2)
                SKIP
                LOOP

            endif

            // build name of index file from database fields

            cNtx_Name = alltrim(_KFILEPATH+trim(File_Name))+'.'+alltrim(File_Ext)

            // if cNtx_Name is empty, no index is requested, but may be pack, or archive functions
            // to be performed on owner file.

            if cNtx_Name = '.'
                cNtx_Name = ''   // skip if not indexing but Max_Recs checking
            endif

            // Get options data from database fields:

            cNtx_Key  = trim(Index_Key)
            lPack_Opt = Pack
            lMemo_Opt = Memopack

            nMaxRecs = Max_Recs
            cMaxRFil = Max_RFile

            M->cDateFld = Date_Field
            M->dMaxDate = Max_Date
            M->nMaxDays = Max_Days
            M->cMaxDFil = Max_DFile

            if file(_KFILEPATH+cTable_Name)

                k_XUse(cTable_Name,iif(!empty(OwnerAlias),OwnerAlias,'TABLENAME'),0)

                if neterr()

                    if lStat_Rep

                        k_ToPrn()

                        @ prow()+1,00 say 'File Use Conflict - Unable to Index File: '+cTable_Name

                        k_ToScr()

                    endif

                    k_KeyList('UNABLE TO INDEX: '+cTable_Name)

                    SELECT DataLink
                    SKIP
                    LOOP

                else
                    nTables++
                endif

            else

                SELECT DataLink
                SKIP
                LOOP

            endif

            k_Box(04,05,06,75)

            @ 05,07 say 'WORKING ON: '+cTable_Name + ' / ' + cNtx_Name

            if nMaxRecs > 0

                @ 05,60 say 'ARCHIVE-R '

                if empty(cMaxRFil)

                    DELETE FOR recno() <= (reccount() - nMaxRecs)
                    PACK

                else


                    COPY TO ___erase FOR recno() <= (reccount() - nMaxRecs)

                    DELETE FOR recno() <= (reccount() - nMaxRecs)
                    PACK

                    if !file(cMaxRFil)
                        COPY STRUCTURE TO (cMaxRFil)
                    endif

                    nMax_Area = select()

                    k_SUse(cMaxRFil,'CMAXRFIL',0)

                    APPEND FROM ___erase

                    USE

                    ERASE ___erase.dbf

                    SELECT (nMax_Area)

                endif

            endif


            if !empty(M->dMaxDate)

                @ 05,60 say 'ARCHIVE-D1'

                if empty(cMaxDFil)

                    DELETE FOR &cDateFld <= dMaxDate
                    PACK

                else

                    COPY TO ___erase FOR &cDateFld <= dMaxDate

                    DELETE FOR &cDateFld <= dMaxDate
                    PACK

                    if !file(cMaxDFil)
                        COPY STRUCTURE TO (cMaxDFil)
                    endif

                    nMax_Area = select()

                    k_SUse(cMaxDFil,'CMAXDFIL',0)

                    APPEND FROM ___erase

                    USE

                    ERASE ___erase.dbf

                    SELECT (nMax_Area)

                endif

            endif

            if !empty(M->nMaxDays)

                @ 05,60 say 'ARCHIVE-D2'

                if empty(cMaxDFil)

                    DELETE FOR ( date() - &cDateFld  ) >= nMaxDays
                    PACK

                else

                    COPY TO ___erase FOR ( date() - &cDateFld  ) >= nMaxDays

                    DELETE FOR ( date() - &cDateFld  ) >= nMaxDays
                    PACK

                    if !file(cMaxDFil)
                        COPY STRUCTURE TO (cMaxDFil)
                    endif

                    nMax_Area = select()

                    k_SUse(cMaxDFil,'CMAXDFIL',0)

                    APPEND FROM ___erase

                    USE

                    ERASE ___erase.dbf

                    SELECT (nMax_Area)


                endif


            endif

            if lPack_Opt .or. M->nMaxRecs > 0 .or. M->nMaxDays > 0 .or. !empty(M->dMaxDate)
                @ 05,60 say 'PACK      '
                PACK
            endif

            if lMemo_Opt .or. M->nMaxRecs > 0 .or. M->nMaxDays > 0 .or. !empty(M->dMaxDate)

                @ 05,60 say 'MEMOPACK  '

                lMem_Here = FALSE

                // see if any fields are memo fields, if not, no memo pack necessary

                for nFC = 1 to fcount()
                    if type(field(nFC)) = 'M'
                        lMem_Here = TRUE
                        EXIT
                    endif
                next

                if lMem_Here

                    SELECT TABLENAME

                    COPY TO __TEMP.DBF
                    ZAP
                    APPEND FROM __TEMP.DBF
                    ERASE __TEMP.DBF
                    ERASE __TEMP.DBT

                else

                    @ 05,60 say 'NO MEMOS '

                    inkey(1)

                endif

            endif

            if !empty(cNtx_Name)

                // ntx_name might be empty in cases of unindexed files that are included for Max_Recs checks

                @ 05,60 say 'INDEXING  '

                erase (cNtx_Name)
                index on &cNtx_Key to (cNtx_Name)

            endif

            nNtxs++
            nRecs += reccount()

            if lStat_Rep

                k_ToPrn()

                @ prow(),90 say k_Bold('RECORDS INDEXED: ')+ltrim(str(reccount()))

                k_ToScr()

            endif

            dbCloseArea()

            SELECT DataLink

            if k_RLock()

                REPLACE Use_Count  WITH Use_Count+1, ;
                        Last_Ntxd  WITH date(), ;
                        Last_Ntxt  with time()

            endif

        endif

        SELECT DataLink
        SKIP

    end


END SEQUENCE

SELECT DataLink
dbCloseArea()

if lStat_Rep
    k_HPrintf('reset')
endif

k_ToScr()

if nOld_Area != 0
    SELECT (nOld_Area)
else
    close all
endif

RETURN(NIL)

