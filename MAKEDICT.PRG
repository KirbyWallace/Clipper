/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_MakeDict( cFileSpec ) --> NIL

PARAMETERS:

cFileSpec: the file extention to use (DEFAULT ALL FILES)

SHORT:

Create a file structure listing for all files meeting filespec criteria.

DESCRIPTION:

All dBASE III+ type databases with the extension specified in cFileSpec are 
read and their structure is added to a file called DATADICT.TXT in a format 
that is compatible with the #xtranslate Directives found in the KLIPPER.CH 
header file.  The resulting data dictionary can be used without modification 
in your program. 

If cFileSpec is not specified, the default is ALL files (those that are 
database files are included).

Note also that dBASE III type extended structure databases are created for 
your use.  They have the extention .DFX  You may delete them if they are not 
needed.

NOTE:



EXAMPLE:

k_MakeDict('DBF')

Result: DATADICT.TXT CONTAINS:

<top of file>
// STRUCTURE FOR: IBS_ACT.DBF

FILE_BEGIN IBS_ACT.DBF

    FLD WORK_ORDER, C,   7
    FLD LOCATION  , N,   3

FILE_END IBS_ACT.DBF


// STRUCTURE FOR: IBS_ACTI.DBF

FILE_BEGIN IBS_ACTI.DBF

    FLD WORK_ORDER, C,   7
    FLD LOCATION  , N,   3

FILE_END IBS_ACTI.DBF


// STRUCTURE FOR: IBS_USER.DBF


FILE_BEGIN IBS_USER.DBF

    FLD NAME      , C,   8
    FLD FULLNAME  , C,  32
    FLD LOCATION  , N,   3
    FLD LEVEL     , N,   1
    FLD PASSWORD  , C,  16

FILE_END IBS_USER.DBF

<end of file>


k_MakeDict()

Result:  Without any parameter specified, ALL files in the current directory 
are scanned to see if they are dBASE III+ compatible databases and are 
included in the above file if so.

******************************************************************************/

#include "klipper.ch"
#include "fileio.ch"

FUNCTION k_MakeDict(cFileSpec)

LOCAL    cExt := iif(cFileSpec = NIL, '*', cFileSPec)

LOCAL    datafiles[adir('*.'+cExt)]
LOCAL    nHandle


if !file('DATADICT.TXT')
    nHandle = fcreate('datadict.txt')
else
    nHandle = fopen('datadict.txt',FO_READWRITE)
    fseek(nHandle,0,FS_END)
    fwrite(nHandle,LF+repl('*',80)+LF+'* FILE UPDATE - '+dtoc(date())+'  '+time()+LF+repl('*',80)+LF+LF)
endif

adir('*.'+cExt,datafiles)
aeval(datafiles,{|ArrayElm| __Update_Dict(ArrayElm,nHandle)})

fclose(nHandle)

RETURN(NIL)

FUNCTION __Update_Dict(cDataFileName,nHandle)

FIELD    Field_Name, Field_Type, Field_Len, Field_Dec
LOCAL    DFX     := substr(cDataFileName,1,at('.',cDataFileName))+'DFX'
LOCAL    OldArea := select()


if k_IsDBF(cDataFileName)

    USE (cDataFileName) ALIAS DB_DFX NEW SHARED

    // k_SUse(cDataFileName,,0)

    COPY STRUCTURE EXTENDED to (DFX)

    dbCloseArea()

    USE (DFX) ALIAS DB_DFX NEW EXCLUSIVE
    // k_XUse(DFX,,0)

    fwrite(nHandle,LF+repl('*',80)+LF+'* STRUCTURE FOR: '+cDataFileName+'      AS OF: '+dtoc(date())+'  '+time()+LF+repl('*',80)+LF+LF)
    fwrite(nHandle,'FILE_BEGIN '+cDataFileName+LF+LF)

    goto top

    do while !eof()

        fwrite(nHandle,'    FLD '+Field_Name)
        fwrite(nHandle,+', '+Field_Type)
        if !empty(Field_Len); fwrite(nHandle,', '+str(Field_Len)); endif
        if !empty(Field_Dec); fwrite(nHandle,', '+str(Field_Dec)); endif
        fwrite(nHandle,LF)
        skip

    enddo

    fwrite(nHandle,LF+'FILE_END '+cDataFileName+LF+LF)

    dbCloseArea()

    SELECT (OldArea)

endif

RETURN(NIL)

