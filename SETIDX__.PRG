/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_SetIndex( cFileName, cIndexName ) --> NIL

PARAMETERS:

cFileName  : Database File Name
cIndexName : Index File Name (Optional)

SHORT:

Open Indexes (and set controlling index) according to definition file.

DESCRIPTION:

SEE k_ReIndex() for full description

NOTE:



EXAMPLE:

k_SetIndex('MAIN.DBF') 

Result: opens all index files for MAIN.DBF i.e.:

    SET INDEX TO MAIN1, MAIN2, MAIN3


k_SetIndex('MAIN.DBF','MAIN3.NTX') 

Result: Same as above, but MAIN3.NTX is the controlling index i.e:

    SET INDEX TO MAIN3, MAIN1, MAIN2


******************************************************************************/
#include "klipper.ch"

FUNCTION k_SetIndex(cTableName,cInitControl)

LOCAL    i

LOCAL    cTable_Ext
LOCAL    acTableNtx[15]
LOCAL    nTablePtr
LOCAL    nOld_Area
LOCAL    lNo_Joy
LOCAL    cNtx_Key
LOCAL    cNtx_Name
LOCAL    cTable_Name

MEMVAR   _KFILEPATH, ;
         _KMENUNAME, ;
         _KINDEXNAME,;
         _KINDEXIDX

MEMVAR   GetList

FIELD    FILE_NAME
FIELD    FILE_EXT
FIELD    OWNER_NAME
FIELD    OWNER_EXT
FIELD    OWNERALIAS
FIELD    INDEX_KEY
FIELD    FILE_DESC
FIELD    LAST_NTXD
FIELD    LAST_NTXT
FIELD    USE_COUNT
FIELD    PACK
FIELD    MEMOPACK
FIELD    INCLUDE
FIELD    MAX_RECS
FIELD    MAX_RFILE
FIELD    MAX_DATE
FIELD    MAX_DAYS
FIELD    DATE_FIELD
FIELD    MAX_DFILE
FIELD    FLAG


MEMVAR   j
MEMVAR   cNtx1,cNtx2,cNtx3,cNtx4,cNtx5,cNtx6,cNtx7,cNtx8,cNtx9,cNtx10,cNtx11,cNtx12,cNtx13,cNtx14,cNtx15

PRIVATE  j
PRIVATE  cNtx1,cNtx2,cNtx3,cNtx4,cNtx5,cNtx6,cNtx7,cNtx8,cNtx9,cNtx10,cNtx11,cNtx12,cNtx13,cNtx14,cNtx15


if type('_KFILEPATH') != 'C'
    PUBLIC _KFILEPATH := ''
endif

if type('_KINDEXNAME') != 'C'
    PUBLIC _KINDEXNAME := 'DataLink.DAT'
endif

if type('_KINDEXIDX') != 'C'
    PUBLIC _KINDEXIDX := 'DataLink.TIF'
endif

if !file(_KFILEPATH+_KINDEXNAME)

    if k_QConfirm('Index Control File Missing.  Create?')

        __MakeIdxFile()

    else

        k_Terminate('INDEXSUBSYS: k_SetIndex(): Cannot Open Index Control File')

    endif

endif


nOld_Area = select()

// build the index control file index if missing

if !file(_KFILEPATH+_KINDEXIDX)

    k_XUse(_KINDEXNAME,'DataLink',0)

    INDEX ON lower(Owner_Name) to (_KINDEXIDX)

    dbCloseArea()

    SELECT (nOld_Area)

endif


if at('.',cTableName) > 0   // file ext specified, might not be the default 'dbf'.

    cTable_Name = substr(cTableName,1,at('.',cTableName)-1)
    cTable_Ext  = trim(substr(cTableName,at('.',cTableName)+1,3)) // trim extra in case of ext = '.E   '

else

    // no file extention specified; default is DBF

    cTable_Name = trim(cTableName)
    cTable_Ext = 'dbf'

endif

for i = 1 to 15
    acTableNtx[i] = ''
next

for i = 1 to 15
    j = ltrim(str(i))
    cNtx&j = ''
next


k_SUse(_KINDEXNAME,'DataLink',0)

SET INDEX TO (_KFILEPATH+_KINDEXIDX)

if neterr()

    * retry for a while

    lNo_Joy = TRUE

    for i = 1 to 10

        k_SUse(_KINDEXNAME,'DataLink',0)

        if !neterr()

            SET INDEX TO (_KFILEPATH+_KINDEXIDX)
            lNo_Joy = FALSE

            EXIT

        endif

        inkey(5)

    next

    if lNo_Joy

        k_Terminate('INDEXSUBSYS: k_SetIndex(): Cannot Open Index Control File')

    endif

endif

GOTO TOP

nTablePtr = 1

seek lower(cTable_Name)

if found()

    while lower(trim(Owner_Name)) = lower(trim(cTable_Name))


        // empty FileName/Extention may be related to archive functions, and is not used to SET INDEX

        if ( (lower(trim(Owner_Name)) = lower(trim(cTable_Name))) .and. (lower(trim(Owner_Ext)) = lower(trim(cTable_Ext))) ) .and.;
              !empty(File_Name)

            * this index belongs to this table

            acTableNtx[nTablePtr] = trim(File_Name)+'.'+trim(File_Ext)

            if !file(_KFILEPATH+acTableNtx[nTablePtr])

                if k_QConfirm('Index Missing: '+acTableNtx[nTablePtr]+'. Create?')

                    cNtx_Name   = _KFILEPATH+trim(File_Name)+'.'+trim(File_Ext)
                    cNtx_Key    = trim(Index_Key)

                    SELECT (nOld_Area)

                    INDEX ON &cNtx_Key TO (cNtx_Name)

                    SELECT DataLink

                else

                    k_Terminate('INDEXSUBSYS: k_SetIndex(): INDEX MISSING')

                endif

            endif

            nTablePtr++

            if k_RLock()
                REPLACE Use_Count with Use_Count+1
            endif

        //else

        //    exit

        endif

        SKIP

    end

endif

dbCloseArea()

for i = 1 to k_Alen(acTableNtx)
    if !empty(acTableNtx[i])
        j = ltrim(str(i))
        cNtx&j = _KFILEPATH+trim(acTableNtx[i])
    endif
next

SELECT (nOld_Area)

SET INDEX TO (cNtx1),(cNtx2),(cNtx3),(cNtx4),(cNtx5),(cNtx6),(cNtx7), ;
             (cNtx9),(cNtx10),(cNtx11),(cNtx12),(cNtx13),(cNtx14),(cNtx15)

if cInitControl = NIL

    // only table name specified, no control index, attempt to set control
    // to index file_name = owner_name

    for i = 1 to k_Alen(acTableNtx)

        if lower(cTable_Name) = lower(substr(acTableNtx[i],1,at('.',acTableNtx[i])-1))

            // No controlling Index was specified, just opened all indexes in
            // the order they occured in the index control file.  This index
            // name matches the name of the database file so we can make it the
            // controlling index by default.

            SET ORDER TO i

            EXIT

        endif

    next

else

    // Initial Control Index was specified, make that index the controlling index if it exists.
    // if it does not exist, k_Terminate().  Programmer should be careful to make sure that the
    // controlling index he/she requested is in fact a valid index.  If it is not, the potential
    // for program error is great if we default to something not expected.

    lNo_Joy = TRUE
    cInitControl = trim(substr(cInitControl+space(8),1,8)) // trim off excess of eight chars

    for i = 1 to k_Alen(acTableNtx)

        if lower(cInitControl) == lower(substr(acTableNtx[i],1,at('.',acTableNtx[i])-1))

            * this should be the control index

            SET ORDER TO i

            lNo_Joy = FALSE

            EXIT

        endif

    next

    if lNo_Joy
        k_Terminate('INDEXSUBSYS: k_SetIndex(): REQUESTED CONTROL INDEX INVALID')
    endif

endif

RETURN(NIL)

************************************************************************************************

FUNCTION __makeidxfile
#include "kfile.ch"
#include "klipper.ch"
LOCAL    nOld_Area

MEMVAR   _KFILEPATH
MEMVAR   _KINDEXNAME

MEMVAR   cIdx_File_Name
PRIVATE  cIdx_File_Name := _KFILEPATH+_KINDEXNAME

nOld_Area = select()

SELECT 0

FILE_BEGIN &cIdx_File_Name

    FLD  FILE_NAME,  C, 8
    FLD  FILE_EXT,   C, 3
    FLD  OWNER_NAME, C, 8
    FLD  OWNER_EXT,  C, 3
    FLD  OWNERALIAS, C, 15
    FLD  INDEX_KEY,  C, 75
    FLD  FILE_DESC,  C, 75
    FLD  LAST_NTXD,  D
    FLD  LAST_NTXT,  C, 8
    FLD  USE_COUNT,  N, 12
    FLD  PACK,       L
    FLD  MEMOPACK,   L
    FLD  INCLUDE,    L
    FLD  MAX_RECS,   N, 10
    FLD  MAX_RFILE,  C, 12
    FLD  MAX_DATE,   D
    FLD  MAX_DAYS,   N, 8
    FLD  DATE_FIELD, C, 10
    FLD  MAX_DFILE,  C, 12
    FLD  FLAG,       C, 1

FILE_END &cIdx_File_Name

if (nOld_Area) != 0
    SELECT (nOld_Area)
endif

RETURN(NIL)

